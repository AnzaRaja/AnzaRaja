;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname hw9) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


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
;; 1. Many problems have provided signatures and purpose statements that you  ;;
;;    should not modify.                                                      ;;
;; 2. When we write "complete the following function design", you should      ;;
;;    write the function definition and check-expects.                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;! Problem 1

;; Complete the following function design.

;;! average-of-two-lists : [List-of Number] [List-of Number] -> [List-of Number]
;;! Produces a list of numbers where each number is the average of the
;;! corresponding numbers in the two lists.
(check-expect (average-of-two-lists '() '()) '())
(check-expect (average-of-two-lists (list 2 4 6 8 3 5 6 7) '()) (list 2 4 6 8 3 5 6 7))
(check-expect (average-of-two-lists '() (list 15 32 20 4 17)) (list 15 32 20 4 17))
(check-expect (average-of-two-lists (list 10 20 30 40 50) (list 15 32 20 4 17)) (list 12.5 26 25 22 33.5))
(check-expect (average-of-two-lists (list 10 20) (list 15 32 20 4 17)) (list 12.5 26 20 4 17))
(check-expect (average-of-two-lists (list 10 20 39 104 10000506) (list 15 1)) (list 12.5 10.5 39 104 10000506))

(define (average-of-two-lists l1 l2)
  (cond
    [(and (empty? l1) (empty? l2)) '()]
    [(and (empty? l1) (cons? l2)) l2]
    [(and (cons? l1) (empty? l2)) l1]
    [(and (cons? l1) (cons? l2)) (cons (/ (+ (first l1) (first l2)) 2) 
                                       (average-of-two-lists (rest l1) (rest l2)))]))

;;! Problem 2

;; Complete the following function design *without using the builtin function
;; replicate*.

;;! repeat-strings-solo : Nat [List-of String] -> [List-of String]
;;! (repeat-strings-solo n slist) produces a list of strings where
;;! each output string is the corresponding input string repeated n times.

(check-expect (repeat-strings-solo 5 '()) '())
(check-expect (repeat-strings-solo 5 (list "a" "b" "c" "d")) (list "aaaaa" "bbbbb" "ccccc" "ddddd"))
(check-expect (repeat-strings-solo 2 (list "1" "2" "3" "4")) (list "11" "22" "33" "44"))
(check-expect (repeat-strings-solo 4 (list "hi" "How was your day?" "Sam"))
              (list "hihihihi" "How was your day?How was your day?How was your day?How was your day?" "SamSamSamSam"))

(define (repeat-strings-solo num los)
  (cond
    [(empty? los) '()]
    [(cons? los) (local [;; repeat-string : Number String -> [List-of String]
                         ;; Creates a list of the given string, repeated the given number of times
                         (define (repeat-string n string)
                           (if
                            (= n 0)
                            ""
                            (string-append string (repeat-string (- n 1) string))))]
                   (map (λ (s) (repeat-string num s)) los))]))

#;(define (repeat-string n string)
  (if
   (= n 0)
   '()
   (cons string (repeat-string (- n 1) string))))

;;! Problem 3

;; Complete the following function design *and you may use the builtin
;; replicate.*

;;! repeat-strings : [List-of String] [List-of Nat] -> [List-of String]
;;! (repeat-strings slist nlist) produces a list of strings from slist, where
;;! each is duplicated N times, where N is the corresponding number in
;;! nlist. However:
;;!
;;! 1. If there  are more strings than numbers, assume that the extra strings
;;!    should be repeated twice each.
;;! 2. If there are more numbers than strings, for each extra number N,
;;!    repeat the the string "Extra!" N times.


;;! Problem 4

;; Consider the following data definitions (we have omitted examples and
;; templates).

(define-struct student [name nuid])
;;! A Student is a (make-student String Number)
;;! Interpretation: represents a student

(define-struct grade [nuid course value])
;;! A Grade is a (make-grade Number String Number)
;;! (make-grade nuid course grade) represents the grade that
;;! a student received in a course.

(define-struct student-grades [name grades])
;;! A StudentGrades is a (make-student-grades String [List-of Number]).
;;! (make-student-grades name grades) represents the grades
;;! that a student has received in all courses.

;; Complete the following function design.

;;! students->student-grades: [List-of Student] [List-of Grade] -> [List-of StudentGrades]
;;! Produces a StudentGrade for each student, with the list of grades that
;;! student received. The list produced should have an item for every student in the
;;! input list, even if there are no grades for that student.

