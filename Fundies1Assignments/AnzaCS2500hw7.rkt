;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname hw7) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Usual Instructions:
;; 1. Do not create, modify or delete any line that begins with ";;!". These are
;;    markers that we use to segment your file into parts to facilitate grading.
;; 2. You must follow the _design recipe_ for every problem. In particular,
;;    every function you define must have at least three check-expects (and
;;    more if needed).
;; 3. You must follow the Style Guide:
;;    https://pages.github.khoury.northeastern.edu/2500/2023F/style.html
;; 4. You must submit working code. In DrRacket, ensure you get no errors
;;    when you click Run. After you submit on Gradescope, you'll get instant
;;    feedback on whether or Gradescope can run your code, and your code must
;;    run on Gradescope to receive credit from the autograder.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; New Instructions                                                           ;;
;; 1. You must use list abstractions to receive credit. Do not write directly ;;
;;    recursive functions.                                                    ;;
;; 2. You may use Lambda if you wish.                                         ;;
;; 3. Many problems have provided signatures and purpose statements that you  ;;
;;    should not modify.                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This homework refers to the following data designs.



;;! A Category is one of:
;;! - "Personal"
;;! - "Work"
;;! - "Academic"
;;! Interpretation: a category of tasks in a task list.
(define PERSONAL "Personal")
(define WORK "Work")
(define ACADEMIC "Academic")

(define (category-template cat)
  (cond
    [(string=? cat PERSONAL) ...] 
    [(string=? cat WORK) ...]
    [(string=? cat ACADEMIC) ...]))

(define-struct task [category description priority])
;; An Task is (make-task String Number)
;; Interpretation: A task in a task list, with its category, description, and
;; priority. Lower numbers are more urgent.
(define EX-ASSIGNMENT (make-task ACADEMIC "Finish HW7" 0))
(define EX-LIBRARY (make-task WORK "Finishing shelving books in Snell" 10))
(define EX-PERSONAL (make-task PERSONAL "Do laundry this time" 20))

(define TASK-LIST-1 (list EX-ASSIGNMENT EX-LIBRARY EX-PERSONAL))
(define TASK-LIST-2 (list EX-ASSIGNMENT EX-ASSIGNMENT EX-ASSIGNMENT))
(define TASK-LIST-3 (list EX-LIBRARY EX-LIBRARY EX-LIBRARY))
(define TASK-LIST-4 (list EX-PERSONAL EX-PERSONAL EX-ASSIGNMENT))

(define (task-template t)
  (... (task-category t) ... (task-description t) ... (task-priority t) ...))

;;! Problem 1

;; Design a function called priority-zero that consumes a list of tasks and
;; only produces those with priority 0.

;;! priority-zero : [List-of Task] -> [List-of Task]
;;! Produces a list of tasks with priority 0.

(check-expect (priority-zero (list EX-ASSIGNMENT)) (list (make-task ACADEMIC "Finish HW7" 0)))

(check-expect (priority-zero (list EX-ASSIGNMENT EX-LIBRARY)) (list (make-task "Academic" "Finish HW7" 0)))

(check-expect (priority-zero (list EX-PERSONAL EX-LIBRARY)) '())

(check-expect (priority-zero (list
                              (make-task ACADEMIC "Study for exam 1" 0)
                              (make-task PERSONAL "Take out trash" 4)
                              (make-task ACADEMIC "Do math homework" 0)
                              (make-task PERSONAL "Go to Target" 8)
                              (make-task PERSONAL "Get an iced vanilla latte from Starbucks" 3)
                              (make-task ACADEMIC "Finish recitation quiz" 0)))
              (list (make-task ACADEMIC "Study for exam 1" 0)
                    (make-task ACADEMIC "Do math homework" 0)
                    (make-task ACADEMIC "Finish recitation quiz" 0)))
                              
(define (priority-zero lot)
  (local [;; equal-zero? : Number -> Boolean
          ;; Is the priority of the task equal to zero?
          (define (equal-zero? t)
            (= (task-priority t) 0))]
    (filter equal-zero? lot)))

;;! Problem 2

;; Design a function called priority<= that consumes a priority number and
;; a list of tasks and produces only those with priority less than or equal
;; to the given number.

;;! priority<= : Number [List-of Task] -> [List-of Task]
;;! Produces a list of tasks with priority less than or equal to the given
;;! number.

(check-expect (priority<= 1 (list EX-ASSIGNMENT)) (list (make-task "Academic" "Finish HW7" 0)))

(check-expect (priority<= 5 (list EX-ASSIGNMENT EX-PERSONAL EX-LIBRARY)) (list (make-task "Academic" "Finish HW7" 0)))

(check-expect (priority<= 0 (list EX-PERSONAL EX-LIBRARY)) '())

(check-expect (priority<= 4 (list (make-task ACADEMIC "Study for exam 1" 0)
                              (make-task PERSONAL "Take out trash" 4)
                              (make-task ACADEMIC "Do math homework" 0)
                              (make-task PERSONAL "Go to Target" 8)
                              (make-task PERSONAL "Get an iced vanilla latte from Starbucks" 3)
                              (make-task ACADEMIC "Finish recitation quiz" 0)))
              (list
               (make-task "Academic" "Study for exam 1" 0)(make-task "Personal" "Take out trash" 4)
               (make-task "Academic" "Do math homework" 0)
               (make-task "Personal" "Get an iced vanilla latte from Starbucks" 3)
               (make-task "Academic" "Finish recitation quiz" 0)))

(define (priority<= num lot)
  (filter (lambda (t) (<= (task-priority t) num)) lot))

 
;;! Problem 3

;; Design a function called prioritize that consumes a category and a list of
;; tasks, and sets the priority of all tasks in the given category to 0. The
;; produced list should contain all tasks in the original list.

;;! prioritize : Category [List-of Task] -> [List-of Task]
;;! Produces every task in the given list of tasks. But, sets the priority of
;;! tasks in the given category to zero.

(check-expect (prioritize PERSONAL TASK-LIST-1) (list (make-task ACADEMIC "Finish HW7" 0)
              (make-task WORK "Finishing shelving books in Snell" 10)
              (make-task PERSONAL "Do laundry this time" 0)))

(check-expect (prioritize WORK TASK-LIST-1) (list (make-task ACADEMIC "Finish HW7" 0)
              (make-task WORK "Finishing shelving books in Snell" 0)
              (make-task PERSONAL "Do laundry this time" 20)))

(check-expect (prioritize ACADEMIC TASK-LIST-1) (list (make-task ACADEMIC "Finish HW7" 0)
              (make-task WORK "Finishing shelving books in Snell" 10)
              (make-task PERSONAL "Do laundry this time" 20))) 
 
(define (prioritize cat l)            
   (map (λ (task) (if (string=? (task-category task) cat)
       (make-task cat (task-description task) 0) task))
        l)) 


;;! Problem 4

;; Design a predicate called any-work? that determines if any task in a list
;; is a work task.

;;! any-work? : [List-of Task] -> Boolean
;;! Determines if any task in the given list is a work task.

(check-expect (any-work? TASK-LIST-1) #t)
(check-expect (any-work? TASK-LIST-2) #f)
(check-expect (any-work? TASK-LIST-3) #t)
(check-expect (any-work? TASK-LIST-4) #f)

(define (any-work? l)
  (ormap (λ (task) (string=? WORK (task-category task))) l)) 
                       

;;! Problem 5

;; Design a function called count-academic that consumes a list of tasks and
;; produces the number of tasks in the list that are academic tasks.

;;! count-academic : [List-of Task] -> Number
;;! Produces the number of tasks in the given list that are academic tasks.

(check-expect (count-academic TASK-LIST-1) 1)
(check-expect (count-academic TASK-LIST-2) 3)
(check-expect (count-academic TASK-LIST-3) 0)
(check-expect (count-academic TASK-LIST-4) 1)

(define (count-academic l)
  (length (filter (λ (task) (string=? ACADEMIC (task-category task))) l)))

 



;;! Problem 6

;; Design a function called search that consumes a list of tasks and a string
;; and produces a list of tasks whose description contains the given string.

;;! search : String [List-of Task] -> [List-of Task]
;;! Produces a list of tasks whose description contains the given string.

(check-expect (search TASK-LIST-1 "TA's are sooo cool")  (list (make-task ACADEMIC "TA's are sooo cool" 0)
              (make-task WORK "TA's are sooo cool" 10)
              (make-task PERSONAL "TA's are sooo cool" 20)))
(check-expect (search TASK-LIST-2 "go to sleep") (list (make-task ACADEMIC "go to sleep" 0)
                                                       (make-task ACADEMIC "go to sleep" 0)
                                                       (make-task ACADEMIC "go to sleep" 0)))
(check-expect (search TASK-LIST-3 "get an ice-vanilla latte from starbies")
              (list (make-task WORK "get an ice-vanilla latte from starbies" 10)
                    (make-task WORK "get an ice-vanilla latte from starbies" 10)
                    (make-task WORK "get an ice-vanilla latte from starbies" 10)))

(define (search l str)
  (map (λ (task) (make-task (task-category task) str (task-priority task))) l)) 







;;! Problem 7

;; Design a function called search-work that consumes a string and produces
;; the descriptions of the work tasks that contain the given string.

;;! search-work : String [List-of Task] -> [List-of String]
;;! Produces a list of descriptions of work tasks that contain the given string.

(check-expect (search-work TASK-LIST-1 "Finishing shelving books in Snell") (list EX-LIBRARY))
(check-expect (search-work TASK-LIST-3 "Finishing shelving books in Snell" ) (list EX-LIBRARY EX-LIBRARY EX-LIBRARY))
(check-expect (search-work TASK-LIST-3 "Water the plants") '() )
(check-expect (search-work TASK-LIST-4 "Finishing shelving books in Snell") '() )

(define (search-work l str)
  (filter (λ (task) (and (string=? WORK (task-category task))
                         (string=? str (task-description task)))) l))



 

 







