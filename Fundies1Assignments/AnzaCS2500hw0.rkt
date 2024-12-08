;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname hw0) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


;;! Purpose: An introduction to programming with simple function definitions.

;;! Instructions:
;;! 1. Read the contents of this file, and fill in [TODO] items that appear
;;!    below.
;;! 2. Do not create, modify or delete any line that begins with ";;!", such
;;!    as these lines. These are markers that we use to segment your file into
;;!    parts to facilitate grading.


(require 2htdp/image)

;;! Problem 1

;;! Part A

;; Examine the following function, and:
;; i.   Write down its signature,
;; ii.  Give it an informative purpose statement, and
;; iii. Give the function and its arguments more informative names.

;; [TODO] Signature
;; [TODO] Purpose
(define (detective a b c)
  (if (< (+ (* 12 a) b) 48)
      (string-append "Welcome aboard, " c "!")
      "Sorry, you may not board the ride. :("))

;; [TODO] Better names for detective and its arguments
;; (detective: Number Number String -> String
;; Multiplies a-value with 12 then adds b-value. If result is less than 48, false and if greater than 48, true.
(define (seats-available number1 number2 name)
  (if (< (+ (* 12 number1) number2)  48)
      (string-append "Welcome aboard, " name "!")
      "Sorry, you may not board the ride. :("))

;;! Part B

;; Write the signature of the following function:

;; [TODO] Signature
;;(mystery: String String Number-> String)
(define (mystery x y z)
  (string-append (substring x 0 z)
                 (substring y z)
                 (substring y 0 z)
                 (substring x z)))

;;! Part C

;; Describe the values that mystery produces when you apply it to two identical
;; arguments for x and y.

;; [TODO] Prose description as a comment.
;; Mystery produces the same two input values you entered when you apply it to two identical arguments.

;;! Problem 2

;; You and your friend have been arguing about how best to invest some money.
;; You think you've picked some stocks that give decent gains consistently, but
;; your friend really wants to invest in cryptocurrencies, which she believes
;; have substantially larger gains some good days, but also suffer some losses
;; on some bad days. To settle the debate of which to invest in, you offer to
;; program a simulation of the two choices.

;;! Part A

;; Define a function stock-day which simulates a single day of gain from the
;; stocks you have in mind. Specifically, stock-day should receive as its
;; argument the amount of money you have, and should produce the amount you
;; will have after a 4% gain. For example, (stock-day 1000) should produce 1040.
;; In addition, write three examples. Here is one to get you started:
;;
;; (stock-day 1000) ; produces 1040

;; [TODO] Function definition
;; [TODO] Examples
(define (stock-day a)
  (* 1.04 a))
;(stock-day 1500) ; produces 1560
;(stock-day 1600) ; produces 1664
;(stock-day 1700) ; produces 1768

;;! Part B

;; Define a function crypto-good-day which simulates a single day of gain from
;; cryptocurrencies, assuming it was a good day. Specifically, crypto-good-day
;; should calculate the amount of money you will have after a 10% gain.
;; You must also write three examples of this function.

;; [TODO] Function definition
;; [TODO] Three examples
(define (crypto-good-day a)
  (* 1.10 a))
;; (crypto-good-day 1000) ; produces 1100
;; (crypto-good-day 1500) ; produces 1650
;; (crypto-good-day 2000) ; produces 2200

;;! Part C

;; Define a function crypto-bad-day which simulates a single day of loss from
;; cryptocurrencies, assuming it was a bad day. Specifically, crypto-bad-day
;; should compute the total amount of money you will have after a –2% loss.
;; For example, if you start with $100 in crypto, after a bad day, you will
;; have $98 left. You must also write three examples for this function.

;; [TODO] Function definition
;; [TODO] Three examples
(define (crypto-bad-day a)
  (* 0.98 a))
;; (crypto-bad-day 400) ; produces 392
;; (crypto-bad-day 250) ; produces 245
;; (crypto-bad-day 130) ; produces 127.4

;;! Part D

;; Define a constant STOCK-6-DAYS which is the total amount of money you would
;; have after starting with $1000 and repeatedly investing all of it in stocks
;; six days. You must use the stock-day function.
;; Hint: You can use the value produced by stock-day on the first day as the
;; argument for stock-day on the second day, and so on.

;; [TODO] Define the constant
(define STOCK-6-DAYS
           (stock-day (stock-day (stock-day (stock-day (stock-day (stock-day 1000)))))))

;; Define a constant CRYPTO-6-DAYS which  simulates cryptocurrency trading for
;; 6 days starting with $1,000, alternating crypto-good-day and crypto-bad-day,
;; **starting with crypto-good-day**.

;; [TODO] Define the constant
(define CRYPTO-6-DAYS
  (crypto-bad-day (crypto-good-day (crypto-bad-day (crypto-good-day (crypto-bad-day (crypto-good-day 1000)))))))

;;! Part E

;; Now compare the results! Which one seems to have done better?

;; [TODO] Write which one seems better? Write it as a comment here.
;; STOCK-6-DAYS ; produces 1265.319...
;; CRYPTP-6-DAYS ; produces 1252.726...
;; Both investments started with 1000. STOCK-6-DAYS resulted in higher profit even though
;; the percentage of gain is significantly less than that of CRYPTO-6-DAYS, STOCK-6-DAYS seems better.

;; <file "hw1-problem3.rkt">

;;! Problem 3

;; In western classical music, tones are typically placed on a scale called
;; the twelve-tone scale. We use non-negative integers to refer to each tone.
;; For example 60 refers to the tone called "C" (or the "do" in "do-re-mi")
;; near the middle of a piano, whereas 61 refers to the tone one unit higher.
;; We consider two tones with a gap of a multiple of 12 units between them as
;; equivalent. For example, the tones 0, 60 and 84 are all equivalent: they are
;; all the tone "C". However, tones 60 and 67 are not equivalent.

;;! Part A

;; Define a function called tone-class which consumes a single tone as an
;; argument, and produces its *class*,  which is the smallest non-negative
;; integer that is equivalent to the tone. For example, the class of 60 is 0,
;; the class of 61 is 1, and the class of 0 is 0 itself. You must also write
;; three examples for your function.

;; Hint: Since there are 12 classes starting with zero, you can calculate the
;; class as the remainder. Try looking for relevant functions in the DrRacket
;; Help Desk.

;; [TODO] Function definition
;; [TODO] Three examples
(define (tone-class a)
  (remainder a 12))
;; (tone-class 50) ; produces 2
;; (tone-class 76) ; produces 4
;; (tone-class 99) ; produces 3

;;! Part B

;; The distance between two tones is how far apart they are, while keeping
;; equivalence in mind. Since there are 12 tone classes, the maximum distance
;; between any pair of tones is 12. However, there are two distances you can
;; produce, depending on which tone you consider first:

;; - The distance between tones 60 and 63 is either 3 (counting up) or 9
;;   (counting down).
;; - The distance between 60 and 75 is also either 3 or 9.
;; - The distance between 63 and 70 is 5 or 7.

;; Write a function called tone-distance which consumes two tones as arguments,
;; and produces their distance (either distance), as defined above.
;; Write three examples for tone-distance.

;; [TODO] Function definition
;; [TODO] Thee examples
;; Signature: Number-> Number
;; Purpose: Takes the remainder of two numbers and produces the difference between them.
(define (tone-distance a b)
   (abs (- (tone-class a) (tone-class b))))
;; (tone-distance 80 30) : produces 2
;; (tone-distance 64 51) : produces 1
;; (tone-distance 66 60) : produces 6

;;! Part C

;; On a piano keyboard, each class of twelve tones (a.k.a., an octave) are
;; placed in a standard pattern of eight white and five black keys. If you are
;; not familiar with this pattern, here is a picture of a piano keyboard:

;; https://en.wikipedia.org/wiki/Musical_keyboard#/media/File:Klaviatur-3-en.svg

;; Write a function called keyboard that consumes the height and width
;; of the white keys, and produces an image that looks like a piano octave.
;; The black keys are roughly half the width and about 3/4 the length of the
;; white keys.
;; Note: The picture linked above labels the white keys. Your image does not
;; have to do so.

;; Hint 1: The overlay/align function may be very helpful.
;; Hint 2: You can use "transparent" as a color for a rectangle.

(define (keyboard a b)
   (overlay/offset (rectangle (/ a 14) (/ b 2) "solid" "black") (/ a (- 2.8)) (* b 0.25)
   (overlay/offset (rectangle (/ a 14) (/ b 2) "solid" "black") (/ a (- 4.6)) (* b 0.25)
   (overlay/offset (rectangle (/ a 14) (/ b 2) "solid" "black") (/ a (- 14)) (* b 0.25)
   (overlay/offset (rectangle (/ a 14) (/ b 2) "solid" "black") (/ a 4.7) (* b 0.25)
   (overlay/offset (rectangle (/ a 14) (/ b 2) "solid" "black") (/ a 2.8) (*  b 0.25)
   (overlay/offset (rectangle (/ a 7) b "outline" "black") (* 3.5(/ a 7)) 0
   (overlay/offset (rectangle (/ a 7) b "outline" "black") (* 3(/ a 7)) 0
   (overlay/offset (rectangle (/ a 7) b "outline" "black") (* 2.5 (/ a 7)) 0
   (overlay/offset (rectangle (/ a 7) b "outline" "black") (* 2 (/ a 7)) 0
   (overlay/offset (rectangle (/ a 7) b "outline" "black") (* 1.5(/ a 7)) 0
   (overlay/offset (rectangle (/ a 7) b "outline" "black") (/ a 7) 0
   (rectangle (/ a 7) b "outline" "black")))))))))))))



