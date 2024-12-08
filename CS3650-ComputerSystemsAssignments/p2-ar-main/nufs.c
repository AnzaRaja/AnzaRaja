// based on cs3650 starter code

#include <assert.h>
#include <bsd/string.h>
#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>

#define FUSE_USE_VERSION 26
#include <fuse.h>

#define STORAGE_FILE "data.nufs"

// Constants
#define MAX_FILES 128         // Maximum number of files supported
#define BLOCK_SIZE 4096       // Size of a single block (4KB)
#define NAME_MAX_LEN 64       // Maximum length of a filename

// Structure representing a file or directory entry
typedef struct file_entry {
    char name[NAME_MAX_LEN];   // Name of the file or directory
    char* data[MAX_FILES];    // Array of pointers to data blocks for large files
    size_t size;               // Total size of the file (in bytes)
    int used;                  // Whether the file entry is in use (1 for in use, 0 for free)
    mode_t mode;               // File type and permissions (e.g., regular file or directory)
} file_entry;

file_entry files[MAX_FILES] = {0};  // Array of file entries (initialize to 0)
int file_count = 0;

// Helper: Find a file entry by name
// Purpose: Searches for a file or directory by its name in the file system
// Arguments:
//   - name: The name of the file or directory to search for
// Returns:
//   - Pointer to the found file_entry, or NULL if not found
file_entry* find_file(const char* name) {
    for (int i = 0; i < MAX_FILES; i++) {
        if (files[i].used && strcmp(files[i].name, name) == 0) {
            return &files[i];
        }
    }
    return NULL;
}

// Helper: Find a free file slot
// Purpose: Searches for a free file entry slot to store a new file or directory
// Returns:
//   - Pointer to the first available (unused) file_entry, or NULL if no space is available
file_entry* find_free_slot() {
    for (int i = 0; i < MAX_FILES; i++) {
        if (!files[i].used) {
            return &files[i];
        }
    }
    return NULL;
}

// save filesystem state to disk
void storage_save() {
    FILE* file = fopen(STORAGE_FILE, "wb");
    if(!file) return;

    //save file entries
    for (int i=0; i < MAX_FILES; i++) {
        if (files[i].used) {
            //write file entry
            fwrite(&files[i], sizeof(file_entry), 1, file);

            //write file data blocks
            for (int j = 0; j < (files[i].size + BLOCK_SIZE - 1) / BLOCK_SIZE; j++) {
                if (files[i].data[j]) {
                    fwrite(files[i].data[j], BLOCK_SIZE, 1, file);
                }
            }
        }
    }
    fclose(file);
}

// load filesystem state from disk
void storage_load() {
    FILE* file = fopen(STORAGE_FILE, "rb");
    if (!file) return;

    //clear state
    for (int i = 0; i < MAX_FILES; i++) {
        if (files[i].used) {
            for (int j = 0; j < MAX_FILES; j++) {
                free(files[i].data[j]);
                files[i].data[j] = NULL;
            }
        }
        files[i].used = 0;
    }

    // read file entries
    file_entry entry;
    while(fread(&entry, sizeof(file_entry), 1, file) == 1) {
        // find free slot
        file_entry* slot = find_free_slot();
        if (!slot) break;

        // copy file entry
        memcpy(slot, &entry, sizeof(file_entry));

        // read data blocks
        for (int j = 0; j < (slot->size + BLOCK_SIZE -1) / BLOCK_SIZE; j++) {
            slot->data[j] = malloc(BLOCK_SIZE);
            if (fread(slot->data[j], BLOCK_SIZE, 1, file) != 1) {
                break;
            }
        }
    }
    fclose(file);
}

// Helper: Check if a file is a directory (by mode)
// Purpose: Determines if the file_entry represents a directory
// Arguments:
//   - file: A pointer to the file_entry to check
// Returns:
//   - 1 if the file is a directory, 0 if it's a regular file
int is_directory(file_entry* file) {
    return (file->used && (file->mode & S_IFDIR)); // Check if it's a directory
}

// Checks if a file exists.
// Purpose: Checks if a file or directory exists in the file system
// Arguments:
//   - path: The path of the file or directory
// Returns:
//   - 0 if the file or directory exists, -ENOENT if it does not exist
int nufs_access(const char* path, int mask) {
    if (strcmp(path, "/") == 0 || find_file(path + 1)) {
        return 0;     // Access granted
    }
    return -ENOENT;   // File or directory not found
}

// Gets an object's attributes (type, permissions, size, etc).
// Purpose: Retrieves the attributes of a file or directory (e.g., size, permissions)
// Arguments:
//   - path: The path of the file or directory to retrieve attributes for
//   - st: The stat structure to populate with the file attributes
// Returns:
//   - 0 on success, or -ENOENT if the file or directory is not found
int nufs_getattr(const char* path, struct stat* st) {
    memset(st, 0, sizeof(struct stat));
    if (strcmp(path, "/") == 0) {
        st->st_mode = 040755;     // Root directory mode
        st->st_nlink = 2;         // Root directory has two links ('.' and '..')
    } else {
        file_entry* file = find_file(path + 1);
        if (!file) {
            return -ENOENT;       // File not found
        }
        st->st_mode = file->mode; // File mode (regular file or directory)
        st->st_nlink = 1;         // Regular file has 1 link
        st->st_size = file->size; // File size
    }
    return 0;
}


// List the contents of a directory
// Purpose: Lists all files and directories in the specified directory
// Arguments:
//   - path: The path of the directory to list
//   - buf: The buffer to store the directory contents
//   - filler: The function to call to add items to the buffer
//   - offset: The offset within the directory (not used here)
//   - fi: File information (not used here)
// Returns:
//   - 0 on success, -ENOENT if the directory is not found
int nufs_readdir(const char* path, void* buf, fuse_fill_dir_t filler,
                 off_t offset, struct fuse_file_info* fi) {
    if (strcmp(path, "/") != 0) {
        return -ENOENT;          // Only the root directory is supported
    }
    
    filler(buf, ".", NULL, 0);   // Add current directory (.)
    filler(buf, "..", NULL, 0);  // Add parent directory (..)

    for (int i = 0; i < MAX_FILES; i++) {
        if (files[i].used) {
            // Add both files and directories
            filler(buf, files[i].name, NULL, 0);
        }
    }
    
    return 0;
}

// Creates a filesystem object like a file or directory
// Purpose: Creates a new file or directory
// Arguments:
//   - path: The path of the new file or directory
//   - mode: The mode (file type and permissions) for the new object
//   - rdev: Reserved, not used here
// Returns:
//   - 0 on success, -ENAMETOOLONG if the filename is too long, 
//     -EEXIST if the file already exists, or -ENOSPC if there is no space
//     available for new files
int nufs_mknod(const char* path, mode_t mode, dev_t rdev) {
    if (strlen(path + 1) >= NAME_MAX_LEN) {
        return -ENAMETOOLONG;     // Filename is too long
    }

    if (find_file(path + 1)) {
        return -EEXIST;           // File already exists
    }

    file_entry* slot = find_free_slot();
    if (!slot) {
        return -ENOSPC;           // No space available for a new file
    }

    strcpy(slot->name, path + 1); // Copy filename to slot
    slot->size = 0;
    slot->used = 1;
    slot->mode = mode;

    storage_save();
    return 0;
}

// Creates a directory
// Purpose: Creates a directory in the file system
// Arguments:
//   - path: The path of the directory to create
//   - mode: The mode (file type and permissions) for the new directory
// Returns:
//   - 0 on success, -ENAMETOOLONG if the filename is too long,
//     -EEXIST if the directory already exists, or -ENOSPC if there is no space
//     available for new files
int nufs_mkdir(const char* path, mode_t mode) {
    if (strlen(path + 1) >= NAME_MAX_LEN) {
        return -ENAMETOOLONG;        // Filename is too long
    }

    if (find_file(path + 1)) {
        return -EEXIST;              // Directory already exists
    }

    file_entry* slot = find_free_slot();
    if (!slot) {
        return -ENOSPC;              // No space available for new directory
    }

    strcpy(slot->name, path + 1);    // Copy directory name to slot
    slot->size = 0;
    slot->used = 1;
    slot->mode = S_IFDIR | 0755;     // Directory with default permissions

    return 0;
} 

// Remove a file from the filesystem
// Purpose: Removes a file from the filesystem
// Arguments:
//   - path: The path of the file to remove
// Returns:
//   - 0 on success, -ENOENT if the file doesn't exist
int nufs_unlink(const char* path) {
    file_entry* file = find_file(path + 1);
    if (!file) {
        return -ENOENT;      // File not found
    }

    file->used = 0;          // Mark file as unused
    storage_save();
    return 0;
}

int nufs_link(const char *from, const char *to) {
  int rv = -1;
  printf("link(%s => %s) -> %d\n", from, to, rv);
  return rv;
}

// Remove an empty directory from the filesystem
// Purpose: Removes a directory if it is empty
// Arguments:
//   - path: The path of the directory to remove
// Returns:
//   - 0 on success, -ENOENT if the directory doesn't exist,
//     -ENOTEMPTY if the directory is not empty
int nufs_rmdir(const char* path) {
    file_entry* dir = find_file(path + 1);
    if (!dir || !is_directory(dir)) {
        return -ENOENT;         // Directory not found
    }

    // Check if directory is empty
    for (int i = 0; i < MAX_FILES; i++) {
        if (files[i].used && strncmp(files[i].name, path + 1, strlen(path + 1)) == 0) {
            return -ENOTEMPTY;  // Directory is not empty
        }
    }

    dir->used = 0;    // Mark directory as unused
    storage_save();
    return 0;
}

// Rename a file or directory
// Purpose: Rename a file or directory
// Arguments:
//   - from: The old name of the file or directory
//   - to: The new name for the file or directory
// Returns:
//   - 0 on success, -ENOENT if the file doesn't exist,
//     -ENAMETOOLONG if the new name is too long, or -EEXIST if the new name
//     already exists
int nufs_rename(const char* from, const char* to) {
    file_entry* file = find_file(from + 1);
    if (!file) {
        return -ENOENT;           // File not found
    }

    if (strlen(to + 1) >= NAME_MAX_LEN) {
        return -ENAMETOOLONG;    // New name is too long
    }

    if (find_file(to + 1)) {
        return -EEXIST;          // New name already exists
    }

    strcpy(file->name, to + 1);  // Rename file or directory
    storage_save();
    return 0;
}

int nufs_chmod(const char *path, mode_t mode) {
  int rv = -1;
  printf("chmod(%s, %04o) -> %d\n", path, mode, rv);
  return rv;
}

int nufs_truncate(const char *path, off_t size) {
  int rv = -1;
  printf("truncate(%s, %ld bytes) -> %d\n", path, size, rv);
  return rv;
}

// This is called on open, but doesn't need to do much
// since FUSE doesn't assume you maintain state for
// open files.
// You can just check whether the file is accessible.
int nufs_open(const char *path, struct fuse_file_info *fi) {
  int rv = 0;
  printf("open(%s) -> %d\n", path, rv);
  return rv;
}

// Read data from a file
// Purpose: Read data from a file at a specific offset
// Arguments:
//   - path: The path of the file to read
//   - buf: The buffer to store the read data
//   - size: The number of bytes to read
//   - offset: The offset from which to start reading
//   - fi: File information (not used here)
// Returns:
//   - The number of bytes read, 0 if end of file is reached, or -ENOENT if
//     the file doesn't exist
int nufs_read(const char* path, char* buf, size_t size, off_t offset,
              struct fuse_file_info* fi) {
    file_entry* file = find_file(path + 1);
    if (!file) {
        return -ENOENT; // File not found
    }

    if (offset >= file->size) {
        return 0;       // End of file reached
    }

    size_t to_read = size;
    if (offset + size > file->size) {
        to_read = file->size - offset;  // Adjust read size if we are reading past the file's end
    }

    size_t bytes_read = 0;
    size_t block_offset = offset % BLOCK_SIZE;
    size_t block_num = offset / BLOCK_SIZE;

    while (bytes_read < to_read) {
        // Check if we have a block to read from
        if (!file->data[block_num]) {
            break;
        }

        size_t read_size = BLOCK_SIZE - block_offset;
        if (read_size > (to_read - bytes_read)) {
            read_size = to_read - bytes_read;
        }

        memcpy(buf + bytes_read, file->data[block_num] + block_offset, read_size);
        bytes_read += read_size;

        block_offset = 0;
        block_num++;
    }

    return bytes_read;
}

// Write data to a file
// Purpose: Write data to a file at a specific offset
// Arguments:
//   - path: The path of the file to write to
//   - buf: The buffer containing the data to write
//   - size: The number of bytes to write
//   - offset: The offset from which to start writing
//   - fi: File information (not used here)
// Returns:
//   - The number of bytes written, or -ENOENT if the file doesn't exist
int nufs_write(const char* path, const char* buf, size_t size, off_t offset,
               struct fuse_file_info* fi) {
    file_entry* file = find_file(path + 1);
    if (!file) {
        return -ENOENT;      // File not found
    }

    size_t new_size = offset + size;
    size_t max_blocks = (new_size + BLOCK_SIZE - 1) / BLOCK_SIZE;
    size_t bytes_written = 0;
    size_t block_offset = offset % BLOCK_SIZE;
    size_t block_num = offset / BLOCK_SIZE;

    while (bytes_written < size) {
        if (!file->data[block_num]) {
            file->data[block_num] = malloc(BLOCK_SIZE);
            memset(file->data[block_num], 0, BLOCK_SIZE);
        }

        size_t to_write = BLOCK_SIZE - block_offset;
        if (to_write > (size - bytes_written)) {
            to_write = size - bytes_written;
        }

        memcpy(file->data[block_num] + block_offset, buf + bytes_written, to_write);
        bytes_written += to_write;

        block_offset = 0;
        block_num++;
    }

    if (new_size > file->size) {
        file->size = new_size;
    }

    storage_save();
    return bytes_written;
}

// Update the timestamps on a file or directory.
int nufs_utimens(const char *path, const struct timespec ts[2]) {
  int rv = -1;
  printf("utimens(%s, [%ld, %ld; %ld %ld]) -> %d\n", path, ts[0].tv_sec,
         ts[0].tv_nsec, ts[1].tv_sec, ts[1].tv_nsec, rv);
  return rv;
}

// Extended operations
int nufs_ioctl(const char *path, int cmd, void *arg, struct fuse_file_info *fi,
               unsigned int flags, void *data) {
  int rv = -1;
  printf("ioctl(%s, %d, ...) -> %d\n", path, cmd, rv);
  return rv;
}

// Initialize the filesystem operations
void nufs_init_ops(struct fuse_operations *ops) {
  memset(ops, 0, sizeof(struct fuse_operations));
  ops->access = nufs_access;
  ops->getattr = nufs_getattr;
  ops->readdir = nufs_readdir;
  ops->mknod = nufs_mknod;
  // ops->create   = nufs_create; // alternative to mknod
  ops->mkdir = nufs_mkdir;
  ops->link = nufs_link;
  ops->unlink = nufs_unlink;
  ops->rmdir = nufs_rmdir;
  ops->rename = nufs_rename;
  ops->chmod = nufs_chmod;
  ops->truncate = nufs_truncate;
  ops->open = nufs_open;
  ops->read = nufs_read;
  ops->write = nufs_write;
  ops->utimens = nufs_utimens;
  ops->ioctl = nufs_ioctl;
};

struct fuse_operations nufs_ops;

// Main function to mount the filesystem
int main(int argc, char* argv[]) {
  assert(argc > 2 && argc < 6);
  printf("Mounting file system at %s\n", argv[--argc]);  // Debug message
  // storage_init(argv[--argc]);
    storage_load();
  nufs_init_ops(&nufs_ops);
  return fuse_main(argc, argv, &nufs_ops, NULL);
}

