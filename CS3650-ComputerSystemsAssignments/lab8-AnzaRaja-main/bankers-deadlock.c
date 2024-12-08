struct account
{
  long balance;
  /* add a mutex to account to prevent races on balance */
  /* remember to initialize the mutex before using it */ 
  pthread_mutex_t mtx;
}

