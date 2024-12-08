;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |CS2500 hw4|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;;! Problem 1

(define-struct person [name next])
;;! A Line is one of:
;;! - "end of line"
;;! - (make-person String Line)
;;! Interpretation: A line of poeple.

(define LINE-EX-1 "end of line")
(define LINE-EX-2 (make-person "Alice" "end of line"))
(define LINE-EX-3 (make-person "Alice" (make-person "Bob" "end of line")))

;;! Part A

;; Write the template for Line.


;;! Part B

;; Design a function called count-people that counts the number of people in
;; a line.


;;! Part C

;; Design a predicate called waldo-in-line? that determines if a person named
;; "Waldo" is in the line.


;;! Part D

;; Design a function that removes the first "Waldo" in the line. It should have the
;; signature remove-waldo : Line -> Line.



;;! Problem 2


(define-struct quest-entry [name completed next])
;;! A QuestLog is one of:
;;! - "empty"
;;! - (make-quest-entry String Boolean QuestLog)
;;! Interpretation: A quest log where each entry contains a quest name and a
;;! boolean that indicates if that quest is completed.

;;! Part A

;; Complete the data design for QuestLog (examples and template)
(define QUESTLOG-0 "empty")
(define QUESTLOG-1 (make-quest-entry "Learn a language" #true QUESTLOG-0))
(define QUESTLOG-2 (make-quest-entry "Check out an escape room" #false QUESTLOG-1))
(define QUESTLOG-3 (make-quest-entry "Bungee jumping" #true QUESTLOG-2))
(define QUESTLOG-4 (make-quest-entry "Snorkeling" #false QUESTLOG-3))
;; Template
;; questlog-templ : QuestLog -> ?
(define (questlog-templ q)
  (cond
    [(string? q) ...]
    [(quest-entry? q) (... (quest-entry-name q) ...
                        (quest-entry-completed q) ...
                        (questlog-templ (quest-entry-next q)... ))]))

;;! Part B

;; Design a function called count-completed-quests that counts the number of
;; completed quests in a quest log.

;; count-completed-quests : QuestLog -> NaturalNumber
;; Counts the number of quests completed in a given QuestLog
(check-expect (count-completed-quests QUESTLOG-0) 0)
(check-expect (count-completed-quests QUESTLOG-1) 1)
(check-expect (count-completed-quests QUESTLOG-2) 1)
(check-expect (count-completed-quests QUESTLOG-3) 2)
(check-expect (count-completed-quests QUESTLOG-4) 2)

(define (count-completed-quests c)
  (cond
    [(string? c) 0]
    [(quest-entry? c) (if (quest-entry-completed c)
                          (+ 1 (count-completed-quests (quest-entry-next c)))
                          (count-completed-quests (quest-entry-next c)))]))
                      
;;! Part C

;; Design a function that consumes a QuestLog and only produces the incomplete
;; quests. It should have the signature incomplete-quests : QuestLog -> QuestLog.

;; incomplete-quests : QuestLog -> QuestLog
;; Produces a QuestLog with the incomplete quests
(check-expect (incomplete-quests QUESTLOG-0) "empty")
(check-expect (incomplete-quests QUESTLOG-1) "empty")
(check-expect (incomplete-quests QUESTLOG-2) (make-quest-entry "Check out an escape room" #false "empty"))
(check-expect (incomplete-quests QUESTLOG-3) (make-quest-entry "Check out an escape room" #false "empty"))
(check-expect (incomplete-quests QUESTLOG-4) (make-quest-entry "Snorkeling" #false
                                                               (make-quest-entry "Check out an escape room" #false "empty")))

(define (incomplete-quests i)
   (cond
    [(string? i) i]
    [(and (quest-entry? i) (not (quest-entry-completed i))) (make-quest-entry (quest-entry-name i)
                                                                              (quest-entry-completed i)
                                                                              (incomplete-quests (quest-entry-next i)))]
    [(and (quest-entry? i) (quest-entry-completed i)) (incomplete-quests (quest-entry-next i))]))

;;! Part D

;; Design a function that consumes a QuestLog and produces a new QuestLog with
;; the same quests, but all marked completed. Call the function mark-all-completed.

;; mark-all-completed : QuestLog -> QuestLog
;; Produces a new QuestLog with all quests marked as completed
(check-expect (mark-all-completed QUESTLOG-0) "empty")
(check-expect (mark-all-completed QUESTLOG-1) (make-quest-entry "Learn a language" #true "empty"))
(check-expect (mark-all-completed QUESTLOG-2) (make-quest-entry "Check out an escape room" #true
                                                                (make-quest-entry "Learn a language" #true "empty")))
(check-expect (mark-all-completed QUESTLOG-3) (make-quest-entry "Bungee jumping" #true
                                                                (make-quest-entry "Check out an escape room" #true
                                                                                  (make-quest-entry "Learn a language" #true "empty"))))
(check-expect (mark-all-completed QUESTLOG-4) (make-quest-entry "Snorkeling" #true
                                                                (make-quest-entry "Bungee jumping" #true
                                                                                  (make-quest-entry "Check out an escape room" #true
                                                                                                    (make-quest-entry "Learn a language" #true "empty")))))
(define (mark-all-completed m)
  (cond
    [(and (string? m) (string=? m "empty")) m]
    [(quest-entry? m) (make-quest-entry
                       (quest-entry-name m)
                       #true
                       (mark-all-completed (quest-entry-next m)))]))

;;! Problem 3

;; This problem has a partially-completed data definition that represents a
;; workout sequence.

(define-struct cardio [rest])
(define-struct strength [rest])
(define-struct flexibility [rest])
;;! A Workout is one of:
;;! - (make-cardio Workout)
;;! - (make-strength Workout)
;;! - (make-flexibility Workout)
;;! - "done"
;;! Interpretation: A list of exercises in a long workout.

;;! Part A

;; Give three examples of Workouts.


;;! Part B

;; Write the template for Workouts.




;;! Part C

;; Design a function called recovery-sequence to generate the "recovery" sequence for a given
;; Workout. In the recovery sequence, cardio exercises become flexibility
;; exercises, strength exercises become cardio exercises, and flexibility
;; exercises become strength exercises.

