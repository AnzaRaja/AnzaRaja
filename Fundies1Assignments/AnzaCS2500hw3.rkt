;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname hw3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Purpose: Recipe recipe practice, now with unions and self-referential data definitions.

(require 2htdp/image)
(require 2htdp/universe)

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

;; Consider the following structure definitions:
(define-struct blender [brand wattage crushes-ice?])
(define-struct microwave [brand power-level])
(define-struct kettle [brand capacity])
(define-struct toaster [brand slices])

;;! Part A

;; Complete four data designs for each structure called Blender, Microwave,
;; Kettle, and Toaster.

;; A Blender is a (make-blender String Integer Boolean)
;; Interpretation : Represents the specifications of a blender with the fields:
;; - brand : the brand name of the blender
;; - wattage : the electrical power of the blender in Watts
;; - crushes-ice? : whether the blender crushes ice
;; Examples :
(define BLENDER-1 (make-blender "Ninja" 900 #false))
(define BLENDER-2 (make-blender "nutribullet" 1200 #true))
(define BLENDER-3 (make-blender "BlendJet" 1000 #false))
;; Template:
;; blender-templ : Blender -> ?
(define (blender-templ b)
  (... (blender-brand b) ...
       (blender-wattage b) ...
       (blender-crushes-ice? b) ...))

;; A Microwave is a (make-microwave String Integer)
;; Interpretation : Represents the specifications of a microwave with the fields:
;; - brand : the brand name of the microwave
;; - power-level : the power level of the microwave
;; Examples :
(define MICROWAVE-1 (make-microwave "Kennmore" 10))
(define MICROWAVE-2 (make-microwave "Samsung" 10))
(define MICROWAVE-3 (make-microwave "LG" 10))
;; Template:
;; blender-templ : Blender -> ?
(define (microwave-templ m)
  (... (microwave-brand m) ...
       (microwave-power-level m) ...))

;; A Kettle is a (make-kettle String Number)
;; Interpretation : Represents the specifications of a kettle with the fields:
;; - brand : the brand name of the kettle
;; - capacity : the maximun number of ounces the kettle can hold measured in oz
;; Examples :
(define KETTLE-1 (make-kettle "Hamilton Beach" 56))
(define KETTLE-2 (make-kettle "Smeg" 57))
(define KETTLE-3 (make-kettle "Chefman" 34))
;; Template:
;; kettle-templ : Kettle -> ?
(define (kettle-templ k)
  (... (kettle-brand k) ...
       (kettle-capacity k) ...))

;; A Toaster is a (make-toaster String Integer)
;; Interpretation : Represents the specifications of a toaster with the fields:
;; - brand : the brand name of the toaster
;; - slices : the maximum number of bread slices that can be toasted at once
;; Examples :
(define TOASTER-1 (make-toaster "Haden" 4))
(define TOASTER-2 (make-toaster "Revolution" 2))
(define TOASTER-3 (make-toaster "Cadco" 6))
;; Template:
;; toaster-templ : Toaster -> ?
(define (toaster-templ t)
  (... (toaster-brand t) ...
       (toaster-slices t) ...))

;;! Part B

;; Complete a data design called Appliance, which can represent any appliance
;; listed above.

;; An Appliance is one of
;; - Blender
;; - Microwave
;; - Kettle
;; - Toaster
;; Interpretation: Represents an existing appliance
;; Example:
(define APPLIANCE-1 BLENDER-1)
(define APPLIANCE-2 MICROWAVE-1)
(define APPLIANCE-3 KETTLE-1)
(define APPLIANCE-4 TOASTER-1)
;; Template:
;; appliance-templ : Appliance -> ?
(define (appliance-templ ap)
  (cond
    [(blender? ap) (blender-templ ap)]
    [(microwave? ap) (microwave-templ ap)]
    [(kettle? ap) (microwave-templ ap)]
    [(toaster? ap) (toaster-templ ap)]))


;;! Part C

;; Complete a data design called Kitchen, which may have 1--3 appliances.
;; (If you have read ahead to lists, do not use lists.)

;; An OptionalAppliance is one of :
;; Appliance
;; #false
;; Template:
;; optional-appliance-templ : OptionalAppliance -> ? 
(define (optional-appliance-templ oa)
  (cond
    [(boolean? oa) ...]
    [else ...]))
    

(define-struct kitchen [a1 a2 a3])
;; A Kitchen is (make-kitchen Appliance OptionalAppliance OptionalAppliance)
;; Interpretation : Represents a kitchen with atleast one appliance and a maximum number of 3 appliances with the fields:
;; - a1 : An Appliance being either a toaster, kettle, microwave or blender
;; - a2 : An OptionalAppliance being an Appliance or #false
;; - a3 : An OptionalAppliance being an Appliance or #false
;; Example:
(define KITCHEN-1 (make-kitchen BLENDER-1 #false #false))
(define KITCHEN-2 (make-kitchen BLENDER-2 MICROWAVE-1 #false))
(define KITCHEN-3 (make-kitchen TOASTER-1 KETTLE-1 MICROWAVE-3))
;; Template:
;; kitchen-templ : Kitchen -> ?
(define (kitchen-templ k)
  (... (kitchen-a1 k) ...
       (kitchen-a2 k) ...
       (kitchen-a3 k)))

;;! Part D

;; Design a function that takes a Kitchen and produces another Kitchen
;; that is identical, except that all microwaves have their power-level
;; incremented by 50.

;; microwave-appliance? : OptionalAppliance -> OptionalAppliance
;; Checks whether an Appliance is a Microwave and if true, updates it.
(check-expect (microwave-appliance? APPLIANCE-1) (make-blender "Ninja" 900 #false))
(check-expect (microwave-appliance? APPLIANCE-2) (make-microwave "Kennmore" 60))
(check-expect (microwave-appliance? APPLIANCE-3) (make-kettle "Hamilton Beach" 56))

(define (microwave-appliance? ma)
  (if
    (microwave? ma)
    (make-microwave
     (microwave-brand ma)
     (+ 50 (microwave-power-level ma)))
    ma))

;; increase-power-level : Kitchen -> Kitchen
;; Produces a new Kitchen with the microwave power-level incremented by 50.
(check-expect (update-power-level KITCHEN-2) (make-kitchen BLENDER-2 (make-microwave "Kennmore" 60) #false))
(check-expect (update-power-level KITCHEN-1) (make-kitchen BLENDER-1 #false #false))
(check-expect (update-power-level KITCHEN-3) (make-kitchen TOASTER-1 KETTLE-1 (make-microwave "LG" 60)))

(define (update-power-level ipl)
  (make-kitchen
   (microwave-appliance? (kitchen-a1 ipl))
   (microwave-appliance? (kitchen-a2 ipl))
   (microwave-appliance? (kitchen-a3 ipl))))

;;! Problem 2

;; You work at a vehicle dealership, and you need to keep track of different
;; types of vehicles: cars, motorcycles, and trucks. For each car, you track
;; its brand, mileage, and number of seats. For each motorcycle, you track its
;; brand, mileage, and engine size. For each truck, you track its brand, mileage
;; and payload capacity.

;;! Part A

;; Complete a data design called Vehicle that can represent any one vehicle.

(define-struct automobile [brand mileage number-of-seats])
;; An Automobile is a (make-automobile String Number Integer)
;; Interpretation : Represents the details of an automobile with the fields:
;; - brand : the brand name of the automobile
;; - mileage : the total amount of miles that the automobile has actively been on the road for
;; - number-of-seats : the total amount of seats the automobile has
;; Examples :
(define AUTOMOBILE-1 (make-automobile "BMW" 5000 2))
(define AUTOMOBILE-2 (make-automobile "Mercedes" 9000 5))
(define AUTOMOBILE-3 (make-automobile "Toyota" 12000 7))
(define AUTOMOBILE-4 (make-automobile "Audi" 120000 7))
;; Template:
;; automobile-templ : Automobile -> ?
(define (automobile-templ a)
  (... (automobile-brand a) ...
       (automobile-mileage a) ...
       (automobile-number-of-seats a) ...))

(define-struct motorcycle [brand mileage engine-size])
;; A Motorcycle is a (make-motorcycle String Number Number)
;; Interpretation : Represents the details of a motorcycle with the fields:
;; - brand : the brand name of the motorcycle
;; - mileage : the total amount of miles that the motorcycle has actively been on the road for
;; - engine-size : the engine size of the motorcycle in cc
;; Examples :
(define MOTORCYCLE-1 (make-motorcycle "Trident" 3000 660))
(define MOTORCYCLE-2 (make-motorcycle "Victory" 4200 1731))
(define MOTORCYCLE-3 (make-motorcycle "Rocket" 900 2300))
(define MOTORCYCLE-4 (make-motorcycle "Trident" 101000 2300))
;; Template:
;; motorcycle-templ : Motorcycle -> ?
(define (motorcycle-templ m)
  (... (motorcycle-brand m) ...
       (motorcycle-mileage m) ...
       (motorcycle-engine-size m) ...))

(define-struct truck [brand mileage payload-capacity])
;; A Truck is a (make-truck String Number Number)
;; Interpretation : Represents the details of a truck with the fields:
;; - brand : the brand name of the truck
;; - mileage : the total amount of miles that the truck has actively been on the road for
;; - payload-capacity : the combined weight of cargo and passengers that the truck can carry in pounds
;; Examples :
(define TRUCK-1 (make-truck "Ford" 3000 1711))
(define TRUCK-2 (make-truck "Ram" 4200 7680))
(define TRUCK-3 (make-truck "Chevrolet" 900 4481))
;; Template:
;; truck-templ : Truck -> ?
(define (truck-templ t)
  (... (truck-brand t) ...
       (truck-mileage t) ...
       (truck-payload-capacity t) ...))
  
;; A Vehicle is one of
;; - Automobile
;; - Motorcycle
;; - Truck
;; Interpretation: Represents one of the three possible vehicles
;; Example:
(define VEHICLE-1 AUTOMOBILE-1)
(define VEHICLE-2 MOTORCYCLE-2)
(define VEHICLE-3 TRUCK-3)
(define VEHICLE-4 AUTOMOBILE-4)
(define VEHICLE-5 MOTORCYCLE-4)
;; Template:
;; vehicle-templ : Vehicle -> ?
(define (vehicle-templ v)
  (cond
    [(automobile? v)(automobile-templ v)]
    [(motorcycle? v) (motorcycle-templ v)]
    [(truck? v) (truck-templ v)]))

;;! Part B

;; Design a predicate called `high-mileage?` that determines if a vehicle has
;; is high mileage. Trucks are high-mileage if they have completed more than
;; 250,000 miles, but the others are high-mileage if they have completed more
;; than 100,000 miles.

;; high-mileage : Vehicle -> Boolean
;; Returns a boolean depending on whether a Vehicle has high mileage
(check-expect (high-mileage? VEHICLE-1) #false)
(check-expect (high-mileage? VEHICLE-5) #true)
(check-expect (high-mileage? VEHICLE-3) #false)
(check-expect (high-mileage? VEHICLE-2) #false)
(check-expect (high-mileage? VEHICLE-4) #true)

(define (high-mileage? v)
  (cond
    [(automobile? v) (> (automobile-mileage v) 100000)]
    [(motorcycle? v) (> (motorcycle-mileage v) 100000)]
    [(truck? v) (> (truck-mileage v) 250000)]))

;;! Part C

;; Design a function with the following signature and purpose statement:

;;! add-miles : Vehicle Number -> Vehicle
;;! Adds the given number of miles to the vehicle's mileage.
(check-expect (add-miles VEHICLE-1 200) (make-automobile "BMW" 5200 2))
(check-expect (add-miles VEHICLE-4 741) (make-automobile "Audi" 120741 7))
(check-expect (add-miles VEHICLE-3 23000) (make-truck "Chevrolet" 23900 4481))
(check-expect (add-miles VEHICLE-2 5000) (make-motorcycle "Victory" 9200 1731))
(define (add-miles v n)
  (cond
    [(automobile? v) (make-automobile
                      (automobile-brand v)
                      (+ n (automobile-mileage v))
                      (automobile-number-of-seats v))]
    [(motorcycle? v) (make-motorcycle
                      (motorcycle-brand v)
                      (+ n (motorcycle-mileage v))
                      (motorcycle-engine-size v))]
    [(truck? v) (make-truck
                 (truck-brand v)
                 (+ n (truck-mileage v))
                 (truck-payload-capacity v))]))

;;! Part D

;; Design a function called `describe-vehicle` takes a `Vehicle` and
;; produces one of these strings:
;; - "A car that seats <n> people!"
;; - "A motorcycle with a <n>cc engine!"
;; - "A truck that hauls <n>lbs!"

;; describe-vehicle : Vehicle -> String
;; Produces a string describing a specification of one of the three possible types of Vehicles
(check-expect (describe-vehicle VEHICLE-4) "A car that seats 7 people")
(check-expect (describe-vehicle VEHICLE-1) "A car that seats 2 people")
(check-expect (describe-vehicle VEHICLE-3) "A truck that hauls 4481lbs!")
(check-expect (describe-vehicle VEHICLE-5) "A motorcycle with a 2300cc engine!")

(define (describe-vehicle v)
   (cond
    [(automobile? v) (string-append "A car that seats " (number->string (automobile-number-of-seats v)) " people")]
    [(motorcycle? v) (string-append "A motorcycle with a " (number->string (motorcycle-engine-size v)) "cc engine!")]
    [(truck? v) (string-append "A truck that hauls " (number->string (truck-payload-capacity v)) "lbs!")]))

;;! Problem 3

;; Write a world program that looks and behaves approximately like this:
;;
;; https://pages.github.khoury.northeastern.edu/2500/2023F/starter/hw3_demo.gif
;;
;; The two triangles must be oriented as shown, and they must follow the mouse
;; as shown. Beyond that, feel free to be creative.
;;
;; Your world program should have the following name and signature:

;; target-program : WorldState -> WorldState
;; (define (target-program initial-state)
;;  (big-bang initial-state
;;    ...))

;; (Recall that big-bang produces the final State.)
;;
;; Furthermore:
;; 1. You can define WorldState however you like.
;; 2. When you click Run, the window must *not* appear. i.e., use
;; target-program in Interactions, and not in Definitions.

(define-struct pos [x-xpos x-ypos y-xpos y-ypos])
;; a Position (pos) is a (make-pos Number Number Number Number)
;;Interpretation : pos tracks the current postions of mouse where
;; - x-xpos is the x-coordinate of the triangle tracking the x axis of mouse
;; - x-ypos is the x-coordinate of the trinagle tracking the y axis of mouse
;; - y-xpos is the y-coordinate of the triangle tracking the x axis of mouse
;; - y-ypos is the y-coordinate of the triangle tracking the y axis of mouse 
(define POS-1 (make-pos 23 32 14 45))
(define POS-2 (make-pos 43 56 34 64))
(define POS-3 (make-pos 0 0 0 0))
(define POS-4 (make-pos 100 75 100 75))

(define (pos-temp pt)
  (... (pos-x-xpos pt) ...
       (pos-x-ypos pt) ...
       (pos-y-xpos pt) ...
       (pos-y-ypos pt) ...))

;; target-program : WorldState -> WorldState
;; purpose : draw a mouse tracking program
;; initial state inputs a pos 

(define (target-program initial-state)
  (big-bang initial-state
    [to-draw draw-tri]
    [on-mouse m-loco]))

(define TRI-Y-AXIS (rotate 270 (triangle 100 "solid" "dark purple"))) 
(define TRI-X-AXIS (rotate 180 (triangle 99 "outline" "sky blue")))
(define BACKGROUND (rectangle 500 500 "solid" "medium pink"))
    
;; draw-tri: pos -> Image
;; Purpose: draw triangles on BACKGROUND
(check-expect (draw-tri POS-1) (place-image TRI-X-AXIS
                                            23 32
                                            (place-image TRI-Y-AXIS
                                                         14 45
                                                         BACKGROUND)))

(check-expect (draw-tri POS-2) (place-image TRI-X-AXIS
                                            43 56
                                            (place-image TRI-Y-AXIS
                                                         34 64
                                                         BACKGROUND))) 
(check-expect (draw-tri POS-3) (place-image TRI-X-AXIS
                                           0 0
                                           (place-image TRI-Y-AXIS
                                                        0 0
                                                        BACKGROUND)))
(check-expect (draw-tri POS-4) (place-image TRI-X-AXIS
                                            100 75
                                            (place-image TRI-Y-AXIS
                                                         100 75
                                                         BACKGROUND)))
(define (draw-tri dt)
  (place-image TRI-X-AXIS
               (pos-x-xpos dt) (pos-x-ypos dt)
               (place-image TRI-Y-AXIS
                            (pos-y-xpos dt) (pos-y-ypos dt)
                            BACKGROUND)))

; m-loco : pos Number Number -> pos 
; Purpse : updates triangle position with respect to mouse cursor
(check-expect (m-loco POS-1 80 76 "move") (make-pos 80 20 20 76))
(check-expect (m-loco POS-2 100 99 "move") (make-pos 100 20 20 99))
(check-expect (m-loco POS-3 2 2 "move") (make-pos 2 20 20 2))
(check-expect (m-loco POS-4 74 99 "move") (make-pos 74 20 20 99))
  
(define (m-loco pos x y ml)
  (make-pos x 20 20 y))   ; CENTER NUMBERS WILL BE in check expects (for future ref)



