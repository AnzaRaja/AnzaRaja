;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |CS2500 hw5|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Instructions
;; 1. Do not create, modify or delete any line that begins with ";;!". These are
;;    markers that we use to segment your file into parts to facilitate grading.
;; 2. You must follow the _design recipe_ for every problem. In particular,
;;    every function you define must have at least three check-expects (and
;;    more if needed).
;; 3. You must follow the Style Guide:
;;    https://pages.github.khoury.northeastern.edu/2500/2023F/style.html
;; 4. You must submit working code. In DrRacket, ensure you get on errors
;;    when you click Run. After you submit on Gradescope, you'll get instant
;;    feedback on whether or Gradescope can run your code, and your code must
;;    run on Gradescope to receive credit from the autograder.

;;! Problem 1

;; Consider the three functions below (we have deliberately omitted tests and purpose
;; statements):

;; flip: [List-of Boolean] -> [List-of Boolean]
(define (flip lob)
  (cond
    [(empty? lob) '()]
    [(cons? lob) (cons (not (first lob)) (flip (rest lob)))]))

(define L0 '(0))
(define L1 (cons 4 L0))
(define L2 (cons -7 L1))
(define L3 (cons 12 L2))
(define L4 (cons 132 L3))
(define L5 (cons 0 L4))

;; until-zero: [List-of Number] -> [List-of Number]
;; Purpose: return empty list if 0 is present, else
;; cons first of list with rest of list
(check-expect (until-zero L0) '())
(check-expect (until-zero L1) (list 4))
(check-expect (until-zero L2) (list -7 4))
(check-expect (until-zero L3) (list 12 -7 4))
(check-expect (until-zero L4) (list 132 12 -7 4)) 
(check-expect (until-zero L5) '()) 

(define (until-zero lon)
  (cond
    [(empty? lon) '()]
    [(cons? lon)
     (if (= (first lon) 0)
         '()
         (cons (first lon) (until-zero (rest lon))))]))

(define S0 '())
(define S1 (cons "yo this is a test case ." S0))  
(define S2 (cons "how does cons work? ." S1))
(define S3 (cons "Ta's are super awesome ." S2))

;; words-until-period: [List-of String] -> [List-of String]
;; Purpose: return period if "." is present, else
;; cons first of list with rest of list
(check-expect (words-until-period S0) '())
(check-expect (words-until-period S1) (list "yo this is a test case ."))
(check-expect (words-until-period S2) (list "how does cons work? ."
                                            "yo this is a test case ."))
(check-expect (words-until-period S3) (list "Ta's are super awesome ."
                                            "how does cons work? ."
                                            "yo this is a test case ."))

(define (words-until-period los)
  (cond
    [(empty? los) '()]
    [(cons? los)
     (if (string=? (first los) ".")
         '()
         (cons (first los) (words-until-period (rest los))))]))

;;! Part A

;; It is possible to design a list abstraction that can be used to simplify two
;; of the three functions defined above. Design that list abstraction.

; yea ofc watch me UwU  

;; (define (until-base-case op base los)

;; op is a dr racket built in function where it can be one of
;; - "string=?" for [ListOf String]
;; - "=" for [ListOf Number]
;; Interpretation: be used and represented as a operation
;; built in racket function in intermiedate student level

;; base is the desired base case for the function
;; and can be one of
;; - " "." " a period with one set of quotes
;; - "0" a number
;; Interpretation: be used as a base case for the
;; function 

;; loX is desired [ListOf X] that will be inputting
;; can be one of
;; - [ListOf Number]
;; - [ListOf String]
;; Purpose: be an abstract version of function of
;; generic implementation purposes
(check-expect (until-base-case string=? "." S0) '() )
(check-expect (until-base-case string=? "." S1) (list "yo this is a test case ."))
(check-expect (until-base-case string=? "." S2) (list "how does cons work? ."
                                                      "yo this is a test case ."))
(check-expect (until-base-case string=? "." S3) (list "Ta's are super awesome ." "how does cons work? ."
                                                       "yo this is a test case ."))
(check-expect (until-base-case = 0 L0) '())
(check-expect (until-base-case = 0 L1) (list 4))
(check-expect (until-base-case = 0 L2) (list -7 4))
(check-expect (until-base-case = 0 L3) (list 12 -7 4))
(check-expect (until-base-case = 0 L4) (list 132 12 -7 4))
(check-expect (until-base-case = 0 L5) '())
               
(define (until-base-case op base loX)
(cond
    [(empty? loX) '()]
    [(cons? loX)
     (if (op (first loX) base) ; string and "." or = and 0 
         '()
         (cons (first loX) (until-base-case op base (rest loX))))]))

;;! Part B

;; Use the list abstraction you designed in Part A to rewrite the functions
;; above that you can. Do not modify the code above. Instead, write your
;; functions here and call them flip/v2, until-zero/v2, or words-until-period/v2.

; until-zero/v2 : [listOf Number] -> [ListOf Number]
; Purpose: return empty list if 0 is present, else
;; cons first of list with rest of list
(check-expect (until-zero/v2 L0) '())
(check-expect (until-zero/v2 L1) (list 4))
(check-expect (until-zero/v2 L2) (list -7 4))
(check-expect (until-zero/v2 L3) (list 12 -7 4))
(check-expect (until-zero/v2 L4) (list 132 12 -7 4)) 
(check-expect (until-zero/v2 L5) '())

(define (until-zero/v2 uz)
  (until-base-case = 0 uz))

;; words-until-period/v2 : [ListOf String] -> [ListOf String]
;; Purpose: return period if "." is present, else
;; cons first of list with rest of list
(check-expect (words-until-period/v2 S0) '())
(check-expect (words-until-period/v2 S1) (list "yo this is a test case ."))
(check-expect (words-until-period/v2 S2) (list "how does cons work? ."
                                               "yo this is a test case ."))
(check-expect (words-until-period/v2 S3) (list "Ta's are super awesome ."
                                               "how does cons work? ."
                                               "yo this is a test case ."))
(define (words-until-period/v2 wup)
  (until-base-case string=? "." wup))



;;! Problem 2

;; The objective in this problem is to define the following functions.
;; We have given their signatures, purpose statements, and check-expects.

(define-struct pair [first second])
;; A [Pair X] is a (make-pair X X) representing a pair of any type
;; - first is the first item in the pair
;; - second is the second item in the pair


;; Template:
;; pair-templ : Pair -> ?
#;(define (pair-templ p)
  (cond
    [(empty? p) ...]
    [(pair? p) (... (pair-first p) ...
                    (pair-second p)...
                     (pair-templ (pair-next p)) ...)]))

;; Abstraction
;; change-elements : List-of Any [X -> X] [X -> X] -> List-of Any
(define (change-elements p func1 func2)
  (cond
    [(empty? p) '()]
    [(cons? p)
     (cons (make-pair (func1 (pair-first (first p)))
           (func2 (pair-second (first p))))
           (change-elements (rest p) func1 func2 ))]))

;; strings-or-odds : [List-of [Pair Number]] -> [List-of [Pair String]]
;; For each pair converts the first item to a string and the second to "odd".
(check-expect (strings-or-odds (list (make-pair 53 23) (make-pair 40 11)))
              (list (make-pair "53" "odd") (make-pair "40" "odd")))
(check-expect (strings-or-odds (list (make-pair 20 30) (make-pair 0 1) (make-pair 3 4)))
              (list (make-pair "20" "odd") (make-pair "0" "odd") (make-pair "3" "odd")))
(check-expect (strings-or-odds '()) '())

(define (strings-or-odds p)
  (change-elements p number->string make-odd))

;; make-odd : X -> String
;; returns the string "odd"
(check-expect (make-odd 20) "odd")
(check-expect (make-odd 17) "odd")
(check-expect (make-odd 87) "odd")

(define (make-odd p)
  "odd")

;; alternate-case : [List-of [Pair String]] -> [List-of [Pair String]]
;; Uppercase the first item of each pair.
(check-expect (alternate-case (list (make-pair "hello" "world") (make-pair "this" "is")))
              (list (make-pair "HELLO" "world") (make-pair "THIS" "is")))
(check-expect (alternate-case (list (make-pair "one" "two") (make-pair "three" "four") (make-pair "five" "six")))
              (list (make-pair "ONE" "two") (make-pair "THREE" "four") (make-pair "FIVE" "six")))
(check-expect (alternate-case (list (make-pair "apple" "banana"))) (list (make-pair "APPLE" "banana")))

(define (alternate-case p)
  (change-elements p string-upcase nothing))

;; nothing : X -> X
;; Returns the given X
(check-expect (nothing "hi") "hi")
(check-expect (nothing "this is") "this is")
(check-expect (nothing "teddy-bear") "teddy-bear")
(define (nothing p)
  p)

                
;; flip-or-keep-boolean : [List-of [Pair Boolean]] -> [List-of [Pair Boolean]]
;; Flip the first item of each pair, keep the second.
(check-expect (flip-or-keep-boolean (list (make-pair #true #true) (make-pair #true #true)))
              (list (make-pair #false #true) (make-pair #false #true)))
(check-expect (flip-or-keep-boolean (list (make-pair #false #false) (make-pair #false #false)))
              (list (make-pair #true #false) (make-pair #true #false)))
(check-expect (flip-or-keep-boolean (list (make-pair #true #false) (make-pair #false #true)))
              (list (make-pair #false #false) (make-pair #true #true)))

(define (flip-or-keep-boolean p)
  (change-elements p flip-boolean nothing))

;; flip-boolean : Boolean -> Boolean
;; Changes the sign of a boolean
(check-expect (flip-boolean #true) #false)
(check-expect (flip-boolean #false) #true)

(define (flip-boolean p)
  (if p
      #f
      #t))

;; However, you must not _directly_ use the list template when you define them!
;;
;; Instead, first design a list abstraction (following the list template), then
;; use that abstraction to design the three functions.


;;! Problem 3

;; Objective: Build a Word Game

;; Your goal is to author a word-building game. You will start with an empty 5x1 grid
;; and a hidden list of random letters. When the player clicks on a cell, its
;; contents should be replaced by the next letter in the list. The game concludes
;; when the cells spell a five-letter word. (You should build a short list of
;; five letter words.)
;;
;; Here is a video that demonstrates the game:
;;
;;   https://pages.github.khoury.northeastern.edu/2500/2023F/starter/hw5.gif
;;
;; Here are questions to help you think through your program design:
;;
;; 1. What do you need in your world state? (What changes during the game?)
;;    Come up with a data design to represent the world state.
;;
;; 2. Your program needs to draw a board, handle mouse clicks, and stop when
;;    the player constructs a word or runs out of letters. These are three 
;;    functions that you need to design.
;;
;; 3. Finally, put it all together using big-bang.


;; on-tick : WorldState -> WorldState
;; to-draw : WorldState -> Image 


;(big-bang
;;      INITIAL-WORLD-STATE ;; required - how does the world look at the very beginning
;;      [to-draw TO-DRAW-FUNCTION-NAME] ;; required - what does the world state look like
;;      [EVENT-TYPE-1 HANDLER-FUNCTION-NAME-1]
;;      [EVENT-TYPE-2 HANDLER-FUNCTION-NAME-2]
;;      ...)
;;

(require 2htdp/image)
(require 2htdp/universe)
;; animate-word-building-game : Initial-x -> Initial-x
;; Animate an word-building-game using big-bang
(define (animate-word-building-game initial-x)
  (big-bang
    initial-x ;; initial world state
    [to-draw draw-board] ;; render the world state
    [on-mouse change-letter]
    [stop-when game-over?]))   ;; change world state from one moment to the other

;; draw-board : LetterBox -> Image
;; Draws the letters in the box based on the current state.
#;(check-expect (draw-board (list "A" "B" "C" "D" "E"))
              (cond
                [(empty? (list "A" "B" "C" "D" "E")) (empty-scene 0 0)]
                [(cons? (list "A" "B" "C" "D" "E")) (beside (draw-letter (first (list "A" "B" "C" "D" "E")))
                                                            (draw-board (rest (list "A" "B" "C" "D" "E"))))]))
#;(check-expect (draw-board (list "D" "M" "C" "R" "E"))
              (cond
                [(empty? (list "D" "M" "C" "R" "E")) (empty-scene 0 0)]
                [(cons? (list "D" "M" "C" "R" "E")) (beside (draw-letter (first (list "D" "M" "C" "R" "E")))
                                                            (draw-board (rest (list "D" "M" "C" "R" "E"))))]))
#;(check-expect (draw-board (list "" "" "" "" ""))
              (cond
                [(empty? (list "" "" "" "" "")) (empty-scene 0 0)]
                [(cons? (list "" "" "" "" "")) (beside (draw-letter (first (list "" "" "" "" "")))
                                                       (draw-board (rest (list "" "" "" "" ""))))]))

(define (draw-board letterbox)
  (cond
    [(empty? (first letterbox)) (empty-scene 0 0)]
    [(cons? (first letterbox)) (beside (draw-letter (first (first letterbox)))
                 (draw-board (rest (first letterbox))))]))

;; draw-letter : String -> Image
;; Draws a letter in a box
(check-expect (draw-letter "A") (overlay (text "A" 40 "black" ) (square 50 "outline" "black")))
(check-expect (draw-letter "M") (overlay (text "M" 40 "black" ) (square 50 "outline" "black")))
(check-expect (draw-letter "J") (overlay (text "J" 40 "black" ) (square 50 "outline" "black")))

(define (draw-letter s)
  (overlay (text s 40 "black" ) (square 50 "outline" "black")))



;; change-letter : LetterBox Number Number MouseEvent -> LetterBox
;; Cycles through letters when a box is clicked

(define (change-letter los x y me)
  (if (string=? me "button-up")
      (list (replace-letter (cell-index x) (first los) (first (second los))) (rest (second los)))
      los))
;;

;; cell-index : Number -> Number
;; Gets an index of a cell based on x position
(check-expect (cell-index 150) 3)
(check-expect (cell-index 200) 4)
(check-expect (cell-index 0) 0)
(define (cell-index x)
  (floor (/ x 50)))

;; replace-letter : Number Los -> Los
;; Replaces a single letter
(check-expect (replace-letter 3 LETTERS "m")
              (cond
                [(empty? LETTERS) '()]
                [(cons? LETTERS) (if (= 3 0)
                                     (cons "m" (rest LETTERS))
                                     (cons (first LETTERS) (replace-letter (- 3 1) (rest LETTERS) "m")))]))
(check-expect (replace-letter 4 LETTERS "b")
              (cond
                [(empty? LETTERS) '()]
                [(cons? LETTERS) (if (= 4 0)
                                     (cons "b" (rest LETTERS))
                                     (cons (first LETTERS) (replace-letter (- 4 1) (rest LETTERS) "b")))]))
(check-expect (replace-letter 0 LETTERS "s")
              (cond
                [(empty? LETTERS) '()]
                [(cons? LETTERS) (if (= 0 0)
                                     (cons "s" (rest LETTERS))
                                     (cons (first LETTERS) (replace-letter (- 0 1) (rest LETTERS) "s")))]))

(define (replace-letter x los s)
  (cond
    [(empty? los) '()]
    [(cons? los) (if (= x 0)
                     (cons s (rest los))
                     (cons (first los) (replace-letter (- x 1) (rest los) s)))]))
                 

(define LETTERS
  (list "a" "n" "c" "b" "e" "l" "o" "i" "s" "k" "z" "r" "t"))

(define WINNING-WORDS
  (list "beast" "clean" "rains" "zebra" "skate"))


(define l (list (list "" "" "" "" "") LETTERS))

;; A LetterBox is one of:
;; (cons [List-of String] '())
;; (cons [List-of String] [List-of String]


;; game-over? : LetterBox -> Boolean
;; determines whether a game is over
(define (game-over? letterbox)
  (or
   (win-words (implode (first letterbox)) WINNING-WORDS)
   (empty? (second letterbox))))

;; string-creator : 


;; win-words :   
(define (win-words guess-word criteria)
  (cond
    [(empty? criteria) #false]
    [(cons? criteria) (or
                       (string=? (first criteria) guess-word)
                       (win-words guess-word (rest criteria)))]))




;; next-letter : LOS ->
;; determine what the next letter in the list is
(check-expect (next-letter LETTERS "c") "b")
(check-expect (next-letter LETTERS "r") "t")
(check-expect (next-letter LETTERS "t") "t")

(define (next-letter los s)
  (cond
    [(empty? los) '()]
    [(empty? (rest los)) s]
    [(cons? los ) (if (string=? s (first los))
                      (first (rest los))
                      (next-letter (rest los) s))]))





