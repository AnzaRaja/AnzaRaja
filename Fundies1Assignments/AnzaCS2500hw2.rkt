;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname AnzaCS2500hw2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
;; Purpose: Recipe recipe practice, now with structured data.

;;! Instructions
;;! 1. Do not create, modify or delete any line that begins with ";;!", such
;;!    as these lines. These are markers that we use to segment your file into
;;!    parts to facilitate grading.
;;! 2. You must follow the _design recipe_ for every problem. In particular,
;;!    every function you define must have at least three check-expects (and
;;!    more if needed).
;;! 3. You must follow the Style Guide:
;;!    https://pages.github.khoury.northeastern.edu/2500/2023F/style.html
;;! 4. You must submit working code. In DrRacket, ensure you get on errors
;;!    when you click Run. After you submit on Gradescope, you'll get instant
;;!    feedback on whether or Gradescope can run your code, and your code must
;;!    run on Gradescope to receive credit from the autograder.

;;! Problem 1

;; Consider the following data definition and interpretation.

(define-struct time (hours minutes seconds))
;;! A Time is a (make-time Number Number Number)
;;! Represents the time of day where:
;;! – hours is between 0 and 23
;;! – minutes is between 0 and 59
;;! – seconds is between 0 and 59

;;! Part A
;; Complete the two remaining parts of the data design for Time.

(define TIME1 (make-time 12 30 10))
(define TIME2 (make-time 6 15 0))
(define TIME3 (make-time 15 48 59))
(define TIME4 (make-time 21 59 7))
(define TIME5 (make-time 21 59 59))
(define TIME6 (make-time 23 58 59))
(define TIME7 (make-time 23 59 59))
(define TIME8 (make-time 23 0 59))

(define (time-templ t)
  (... (time-hours t)
   ... (time-minutes t)
   ... (time-seconds t)))

;;! Part B
;; Design a function called tick that adds one second to a Time.

; tick : Time -> Time
; Produces a new time by adding one second to a given time
(check-expect (tick TIME1) (make-time 12 30 11))
(check-expect (tick TIME7) (make-time 0 0 0))
(check-expect (tick TIME8) (make-time 23 1 0))
(check-expect (tick TIME5) (make-time 22 0 0))
(define (tick time)
  (cond [(and (= (time-hours time) 23) (= (time-minutes time) 59) (= (time-seconds time) 59))
         (make-time
          0 0 0)]
        [(and (= (time-minutes time) 59) (= (time-seconds time) 59))
         (make-time
          (+ 1 (time-hours time)) 0 0)]
        [(< (time-seconds time) 59)
         (make-time
          (time-hours time)
          (time-minutes time)
          (+ 1 (time-seconds time)))]
        [else
         (make-time
          (time-hours time) (+ 1 (time-minutes time)) 0)]))

;;! Part C

;; Design a function called time->image that draws an analog clock face with
;; three hands. (The hour hand is shortest and the minute and second hand should
;; be different.)
;;
;; See the link below for a refresher on how an analog clock works
;; https://en.wikipedia.org/wiki/Clock_face
;; Note: The hour hand does not need to base it's position on the minute hand
;; for this assignment

;; time->image : Time -> Image
;; Produces an image of an analog clock face according to the given time.
(check-expect (time->image TIME7) (overlay
                                   (rotate (* (/ (remainder (time-hours TIME7) 12) 12) -360)
                                           (place-image (rectangle 6 30 "solid" "black")
                                                        50 35
                                                        (circle 50 "outline" "black")))
                                   (rotate (* (/ (time-minutes TIME7) 60) -360)
                                           (place-image (rectangle 3 45 "solid" "blue")
                                                        50 30
                                                        (circle 50 "outline" "black")))
                                   (rotate (* (/ (time-seconds TIME7) 60) -360)
                                           (place-image (rectangle 1 40 "solid" "blue")
                                                        50 35
                                                        (circle 50 "outline" "black")))))
(check-expect (time->image TIME4) (overlay
                                   (rotate (* (/ (remainder (time-hours TIME4) 12) 12) -360)
                                           (place-image (rectangle 6 30 "solid" "black")
                                                        50 35
                                                        (circle 50 "outline" "black")))
                                   (rotate (* (/ (time-minutes TIME4) 60) -360)
                                           (place-image (rectangle 3 45 "solid" "blue")
                                                        50 30
                                                        (circle 50 "outline" "black")))
                                   (rotate (* (/ (time-seconds TIME4) 60) -360)
                                           (place-image (rectangle 1 40 "solid" "blue")
                                                        50 35
                                                        (circle 50 "outline" "black")))))

(check-expect (time->image TIME2) (overlay
                                   (rotate (* (/ (remainder (time-hours TIME2) 12) 12) -360)
                                           (place-image (rectangle 6 30 "solid" "black")
                                                        50 35
                                                        (circle 50 "outline" "black")))
                                   (rotate (* (/ (time-minutes TIME2) 60) -360)
                                           (place-image (rectangle 3 45 "solid" "blue")
                                                        50 30
                                                        (circle 50 "outline" "black")))
                                   (rotate (* (/ (time-seconds TIME2) 60) -360)
                                           (place-image (rectangle 1 40 "solid" "blue")
                                                        50 35
                                                        (circle 50 "outline" "black")))))

(define (time->image time)
  (overlay
   (rotate (* (/ (remainder (time-hours time) 12) 12) -360)
           (place-image (rectangle 6 30 "solid" "black")
                        50 35
                        (circle 50 "outline" "black")))
   (rotate (* (/ (time-minutes time) 60) -360)
           (place-image (rectangle 3 45 "solid" "blue")
                        50 30
                        (circle 50 "outline" "black")))
   (rotate (* (/ (time-seconds time) 60) -360)
           (place-image (rectangle 1 40 "solid" "blue")
                        50 35
                        (circle 50 "outline" "black")))))
  
;;! Problem 2

;;! Part A

;; You are a feared restaurant critic whose ratings can make or break the
;; restaurants in Boston. Design a data definition called Review
;; that represents your review of a single restauant. A Review holds the
;; restaurant's name, its cuisine, the dish you ordered, its price, your
;; rating (1--5), and whether or not you saw any rats.

;; A Rating is one of
;; - 1
;; - 2
;; - 3
;; - 4
;; - 5
;; Interpretation : Represents a rating on a scale of 1 to 5
;; Examples:
(define RATING-1 1)
(define RATING-2 2)
(define RATING-3 3)
(define RATING-4 4)
(define RATING-5 5)

(define-struct review [restaurant-name cuisine dish-ordered price rating rats?])
;; A Review is a (make-review String String String Integer Rating String)
;; Interpretation: Represents a review of a single restaurant with the fields:
;;   - restaurant-name - the name of the restaurant
;;   - cuisine - the restaurants cuisine
;;   - dish-ordered - the dish that was ordered
;;   - price - the price of the dish
;;   - rating - the rating on a scale of 1 to 5
;;   - rats? - whether any rats were seen
;; Examples:
(define REVIEW-1 (make-review "Bob's Den" "American" "Chicken Burger with Fries" 18 4 "Yes"))
(define REVIEW-2 (make-review "Doppio Zero" "Italian" "Pasta Alfredo" 25 5 "No"))
(define REVIEW-3 (make-review "McDonalds" "Gourmet" "Double Quarter Pounder" 12 3 "No"))
;; Template:
;; review-templ : Review -> ?
(define (review-templ r)
  (... (review-restaurant-name r) ...
       (review-cuisine r) ...
       (review-dish-ordered r) ...
       (review-price r) ...
       (review-rating r) ...
       (review-rats? r ...)))


;;! Part B

;; Design a function called update-rating that takes a Review and a new rating,
;; and updates the review with the new rating. 

;; update-rating : Review Rating -> Review
;; A Review and a new rating and produces an updated review with a new rating
(check-expect (update-rating REVIEW-1 5) (make-review "Bob's Den" "American" "Chicken Burger with Fries" 18 5 "Yes"))
(check-expect (update-rating REVIEW-3 4) (make-review "McDonalds" "Gourmet" "Double Quarter Pounder" 12 4 "No"))
(check-expect (update-rating REVIEW-2 1) (make-review "Doppio Zero" "Italian" "Pasta Alfredo" 25 1 "No"))
(define (update-rating review nr)
  (make-review (review-restaurant-name review)
               (review-cuisine review)
               (review-dish-ordered review)
               (review-price review)
               nr
               (review-rats? review)))
  

;;! Part C

;; Design a function called rat-sighting that takes a Review and marks it as
;; a restaurant with rats. It also decreases its rating by 1 star, only if
;; the restaurant was not previously known to have rats.

;; rat-sighting : Review -> Review
;; Review and marks as a restaurant with rats and decreases rating by 1 star if the restaurant was not previously known to have rats.
(define (rat-sighting review)
  (make-review
   (review-restaurant-name review)
   (review-cuisine review)
   (review-dish-ordered review)
   (review-price review)
       (if (string=? "No" (review-rats? review))
           (- (review-rating review) 1)
           (review-rating review))
       "Yes"))
  

;;! Problem 3

;; You are in the robot part business, making essential parts for robots.
;; The only parts you make are LIDAR sensors, depth cameras, accelerometers,
;; electric motors, and batteries. For every part, you track the kind of
;; part, the price of the item, and the number of items in stock.

;;! Part A

;; Design data definitions called PartType and Stock to represent
;; a single type of item in stock.

;; A PartType is one of
;; - "LIDAR-sensors"
;; - "Depth-cameras"
;; - "Accelerometers"
;; - "Electric-motors"
;; - "Batteries"
;; Interpretation: Represnts one of the parts sold by the business.
;; Example:
(define PART-TYPE-LIDAR-SENSORS "LIDAR-sensors")
(define PART-TYPE-DEPTH-CAMERAS "Depth-cameras")
(define PART-TYPE-ACCELEROMETERS "Accelerometers")
(define PART-TYPE-ELECTRIC-MOTORS "Electric-motors")
(define PART-TYPE-BATTERIES "Batteries")

;; Template:
;; part-type-templ : PartType -> ?
(define (part-type-templ pt)
  (cond
    [(string=? pt PART-TYPE-LIDAR-SENSORS) ...]
    [(string=? pt PART-TYPE-DEPTH-CAMERAS) ...]
    [(string=? pt PART-TYPE-ACCELEROMETERS) ...]
    [(string=? pt PART-TYPE-ELECTRIC-MOTORS) ...]
    [(string=? pt PART-TYPE-BATTERIES) ...]))

(define-struct stock [part-type price number-in-stock])

;; A Stock is a (make-stock PartType Integer Integer)
;; Interpretation: Represents the stock with the fields:
;;   - part-type - is a Part-Type the type of part sold
;;   - price - the price of a single part
;;   - number-in-stock - the number of items in stock for a single type of part
;; Examples:
(define STOCK-1 (make-stock PART-TYPE-LIDAR-SENSORS 200 40))
(define STOCK-2 (make-stock PART-TYPE-DEPTH-CAMERAS 267 60))
(define STOCK-3 (make-stock PART-TYPE-ACCELEROMETERS 130 52))
(define STOCK-4 (make-stock PART-TYPE-ELECTRIC-MOTORS 180 75))
(define STOCK-5 (make-stock PART-TYPE-BATTERIES 9 80))
;; Template:
;; stock-templ : Stock -> ?
(define (stock-templ s)
  (... (stock-part-type s) ...
       (stock-price s) ...
       (stock-number-in-stock s) ...))


;;! Part B

;; Design a function called discount that takes an Stock and a discount
;; value, and reduces the price by the given value. However, if the price
;; is lower than $10, do not apply the discount. You can assume that the
;; discount is less than the original price.

;; discount : Stock Integer -> Stock
;; The Stock with the price at a discounted value unless the orignal price is less than $10.
(check-expect (discount STOCK-5 14) (make-stock "Batteries" 9 80))
(check-expect (discount STOCK-2 56) (make-stock "Depth-cameras" 117.48 60))
(check-expect (discount STOCK-4 12) (make-stock "Electric-motors" 158.4 75))

(define (discount STOCK dv)
  (make-stock (stock-part-type STOCK)
              (if (< (stock-price STOCK) 10)
                  (stock-price STOCK)
                  (* (stock-price STOCK) (/ (- 100 dv) 100)))
              (stock-number-in-stock STOCK)))

;;! Part C

;; Design a function called greater-value? that takes two Stocks and
;; produces #true iff the value (quantity * price) of the first is greater than
;; or equal to the value of the second.
;; Note: To receive full credit, you will need to write a helper function that
;; follows the template.

;; get-value-of-stock : Stock -> Integer
;; Returns the value of a stock.
(check-expect (get-value-of-stock STOCK-1) 8000)
(check-expect (get-value-of-stock STOCK-2) 16020)
(check-expect (get-value-of-stock STOCK-3) 6760)

(define (get-value-of-stock s)
  (* (stock-price s) (stock-number-in-stock s)))

;; greater-value : STOCK STOCK -> Boolean
;; Boolean whether the value of price multiplied by quantity of the first stock is greater than that of the second stock.
(check-expect (greater-value? STOCK-1 STOCK-2) #f)
(check-expect (greater-value? STOCK-4 STOCK-5) #t)
(check-expect (greater-value? STOCK-3 STOCK-1) #f)

(define (greater-value? s1 s2)
   (>
    (get-value-of-stock s1) (get-value-of-stock s2)))
