;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |CS2500 hw10|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define-struct manager [name team])
(define-struct ic [name])
(define-struct team [name members])

;;! A Manager is a (make-manager String Team)
;;! Interpretation: a manager at a company who directly manages the team.

;;! A Person is one of:
;;! - (make-manager String Team)
;;! - (make-ic String)
;;! Interpretation: A person at a company who is either a manager or an an
;;! individual contributor ("IC").

;;! A Team is a (make-team String [List-of Person])
;;! Interpretation: A team at a company, with a name and a list of members.

;;! Problem 1

;; Define three examples of Manager. One of them should have someone with exactly
;; the same name at two levels of the hierarchy, because that is a common source
;; of confusion at large companies.
(define MANAGER-1 (make-manager "Kate" (make-team "team-1"
                                                  (list (make-ic "Sloan")
                                                        (make-ic "Gavin")
                                                        (make-ic "Andy")))))
(define MANAGER-2 (make-manager "Sam" (make-team "team-2"
                                                 (list (make-ic "Rose")
                                                       (make-manager "Alvin"
                                                                     (make-team "team-3"
                                                                                (list (make-ic "Ally")
                                                                                      (make-ic "Ross"))))))))
(define MANAGER-3 (make-manager "Anna" (make-team "team-4"
                                                  (list (make-ic "Josh")
                                                        (make-ic "Elizabeth")
                                                        (make-ic "Hari")
                                                        (make-ic "Conrad")
                                                        (make-ic "Sofie")
                                                        (make-ic "Alexa")
                                                        (make-manager "Anna"
                                                                      (make-team "team-5"
                                                                                 (list (make-ic "Joe")
                                                                                       (make-ic "Dan")
                                                                                       (make-manager "Carrie"
                                                                                                     (make-team "team-6"
                                                                                                                (list (make-ic "Gabby")
                                                                                                                      (make-ic "Shannon")))))))))))

;;! Problem 2

;; Complete the following function design.

;;! list-direct-reports : String Manager -> [List-of String]
;;! Produces a list of all the direct reports of the manager with the given
;;! name. When several managers have the same name, all of them are included.

(define (person-templ p)
  (cond
    [(manager? p) (... (manager-name p) ...
                   (team-templ (manager-team p)))]
    [(ic? p) (... (ic-name p) ...)]))       
              
(check-expect (list-direct-reports "Kate" MANAGER-1) (list "Sloan" "Gavin" "Andy"))
(check-expect (list-direct-reports "Sam" MANAGER-2) (list "Rose" "Alvin"))
(check-expect (list-direct-reports "Alvin" MANAGER-2) (list "Ally" "Ross"))
(check-expect (list-direct-reports "Anna" MANAGER-3) (list "Josh" "Elizabeth" "Hari" "Conrad" "Sofie" "Alexa" "Anna" "Joe" "Dan" "Carrie"))

(define (list-direct-reports str man)
  (local [;; lop-direct-report : String [List-of Person] -> [List-of String]          
          (define (lop-direct-report srt lop)
            (cond
              [(empty? lop) empty]
              [(manager? (first lop)) (append (list-direct-reports str (first lop))  
                                              (lop-direct-report str (rest lop)))]
              [else (lop-direct-report str (rest lop))]))
          ;; report-list : [ListOf Person] -> [ListOf String]
          ;; returns list of name of who reports to manager      
          (define (report-list rl)
            (cond  
              [(empty? rl) empty]      
              [(manager? (first rl))
                   (cons (manager-name (first rl)) (report-list (rest rl)))]              
              [(ic? (first rl)) (cons (ic-name (first rl)) (report-list (rest rl)))]))]
    
    (append (if (string=? str (manager-name man))  ; same                            
        (report-list (team-members (manager-team man)))
        '() )
        (lop-direct-report str (team-members (manager-team man)))
            )))

;;! Problem 3

;; Complete the following function design. Hint: this requires an accumulator

;;! list-managers : String Manager -> [List-of String]
;;! Produces a list of all the managers who directly manage someone with the
;;! given name. When several people have the same name, list all their managers.

;; list-managers : String Manager -> [List-of String]
;; Produces a list of all the managers who directly manage someone with the
;; ACCUMULATOR
(check-expect (list-managers "Gavin" MANAGER-1)
              (list "Kate"))
(check-expect (list-managers "Ally" MANAGER-2) 
              (list "Alvin")) 
(check-expect (list-managers "Gabby" MANAGER-3)
              (list "Carrie"))
(check-expect (list-managers "Sam" MANAGER-3)
              '())

(define (list-managers name mx) 
  (manager-str name mx (team-members (manager-team mx))))

;; manager-str : Name Manager [List-of Person] -> [List-of String]
;; produces list of manager of a given name
;; ACCUMULATOR 
(define (manager-str name mx lop)
  (local[;; no//r : Name [List-of Person] -> [List-of Managers]
         ;; avoids repeat of name
         (define (no//r n l/o/p) 
           (cond
             [(empty? l/o/p) empty] 
             [(ic? (first l/o/p)) (no//r n (rest l/o/p))]
             [(manager? (first l/o/p)) (append (list-managers n (first l/o/p)) (no//r n (rest l/o/p)))]))]
  (cond
    [(empty? lop) empty] 
    [(ic? (first lop)) (if (string=? name (ic-name (first lop)))
                           (cons (manager-name mx) (no//r name (rest lop)))
                           (manager-str name mx (rest lop)))]
    [(manager? (first lop)) (append (if (string=? name (manager-name (first lop)))
                                        (cons (manager-name mx) (list-managers name (first lop)))
                                        (list-managers name (first lop))) (manager-str name mx (rest lop)))])))
              

