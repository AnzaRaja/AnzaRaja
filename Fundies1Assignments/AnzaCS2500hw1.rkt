;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname hw1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


;; Purpose: An introduction to data design (enumerations) and the design recipe.

;;! Instructions:
;;! 1. Read the contents of this file, and fill in [TODO] items that appear
;;!    below.
;;! 2. Do not create, modify or delete any line that begins with ";;!", such
;;!    as these lines. These are markers that we use to segment your file into
;;!    parts to facilitate grading.
;;! 3. You must follow the _design recipe_ for every problem. In particular,
;;!    every function you define must have at least three check-expects (and
;;!    more if needed).

;;! Problem 1

;; Design a function called concat-space-separator-when-long that consumes two
;; strings and produces a single string that concatenates them. In the result,
;; the two strings should be separated by a space *only if* the first string
;; is longer than 5 characters.

;; concat-space-seperator-when-long: String, String -> String
;; Concatenates two strings into one string and seperates two strings with a space
;; only if the first string has more than 5 characters.
(check-expect (concat-space-seperator-when-long "my" "dog") "mydog")
(check-expect (concat-space-seperator-when-long "green" "butterfly") "greenbutterfly")
(check-expect (concat-space-seperator-when-long "Vanilla" "coffee") "Vanilla coffee")
(define (concat-space-seperator-when-long string1 string2)
  (cond
    [(<= (string-length string1) 5) (string-append string1 string2)]
    [(> (string-length string1) 5) (string-append string1 " " string2)]))
  

;;! Problem 2

;;! Part A

;; Our solar systems traditionally had nine planets. Look them up, and
;; write a data definition called Planet that can represent any one of them.
;; NOTE: name your template planet-template.

;; A Planet is one of
;; - "Mercury"
;; - "Venus"
;; - "Earth"
;; - "Mars"
;; - "Jupiter"
;; - "Saturn"
;; - "Uranus"
;; - "Neptune"
;; - "Pluto"
;; Interpretation: Represents a Planet in our solar system.
;; Example:
(define PLANET-MERCURY "Mercury")
(define PLANET-VENUS "Venus")
(define PLANET-EARTH "Earth")
(define PLANET-MARS "Mars")
(define PLANET-JUPITER "Jupiter")
(define PLANET-SATURN "Saturn")
(define PLANET-URANUS "Uranus")
(define PLANET-NEPTUNE "Neptune")
(define PLANET-PLUTO "Pluto")
;; Template
;; planet-templ : Planet -> ?
(define (planet-templ pl)
  (cond
    [(string=? pl PLANET-MERCURY) ...]
    [(string=? pl PLANET-VENUS) ...]
    [(string=? pl PLANET-EARTH) ...]
    [(string=? pl PLANET-MARS) ...]
    [(string=? pl PLANET-JUPITER) ...]
    [(string=? pl PLANET-SATURN) ...]
    [(string=? pl PLANET-URANUS) ...]
    [(string=? pl PLANET-NEPTUNE) ...]
    [(string=? pl PLANET-PLUTO) ...]))

;;! Part B

;; One way to classify planets is as either terrestrial, gas giant, or dwarf planet.
;; Design a function called planet-kind that consumes a Planet and produces either
;; "terrestrial", "gas giant", or "dwarf planet".

;; planet-kind: String -> String
;; Consumes a Planet and classifies it as either "terrestrial", "gas giant", or "dwarf planet"
(check-expect (planet-kind "Mercury") "terrestrial")
(check-expect (planet-kind "Venus") "terrestrial")
(check-expect (planet-kind "Earth") "terrestrial")
(check-expect (planet-kind "Mars") "terrestrial")
(check-expect (planet-kind "Jupiter") "gas giant")
(check-expect (planet-kind "Saturn") "gas giant")
(check-expect (planet-kind "Uranus") "gas giant")
(check-expect (planet-kind "Neptune") "gas giant")
(check-expect (planet-kind "Pluto") "dwarf planet")
(define (planet-kind Planet)
  (cond
    [(string=? Planet "Mercury") "terrestrial"]
    [(string=? Planet "Venus") "terrestrial"]
    [(string=? Planet "Earth") "terrestrial"]
    [(string=? Planet "Mars") "terrestrial"]
    [(string=? Planet "Jupiter") "gas giant"]
    [(string=? Planet "Saturn") "gas giant"]
    [(string=? Planet "Uranus") "gas giant"]
    [(string=? Planet "Neptune") "gas giant"]
    [(string=? Planet "Pluto") "dwarf planet"]))

;;! Part C

;; Design a predicate called has-moons? that produces true if a planet has any
;; moons.

;; has-moons? : String -> String
;; Consumes a Planet and returns "yes" or "no" regarding whether the Planet has moons.
(check-expect (has-moons? "Mercury") "No")
(check-expect (has-moons? "Venus") "No")
(check-expect (has-moons? "Earth") "Yes")
(check-expect (has-moons? "Mars") "Yes")
(check-expect (has-moons? "Jupiter") "Yes")
(check-expect (has-moons? "Saturn") "Yes")
(check-expect (has-moons? "Uranus") "Yes")
(check-expect (has-moons? "Neptune") "Yes")
(check-expect (has-moons? "Pluto") "Yes")
(define (has-moons? Planet)
  (cond
    [(string=? Planet "Mercury") "No"]
    [(string=? Planet "Venus") "No"]
    [(string=? Planet "Earth") "Yes"]
    [(string=? Planet "Mars") "Yes"]
    [(string=? Planet "Jupiter") "Yes"]
    [(string=? Planet "Saturn") "Yes"]
    [(string=? Planet "Uranus") "Yes"]
    [(string=? Planet "Neptune") "Yes"]
    [(string=? Planet "Pluto") "Yes"]))

;;! Problem 3

;;! Part A

;; Design a data definition called RainbowColor that represents a color of the
;; rainbow. To avoid ambiguity, use the "modern" colors from this Wikipedia page:
;; https://en.wikipedia.org/wiki/Rainbow
;; NOTE: call your template rainbow-color-template.

;; A RainbowColor is one of
;; - "Red"
;; - "Orange"
;; - "Yellow"
;; - "Green"
;; - "Cyan"
;; - "Blue"
;; - "Violet"
;; Interpretation: Represents one of the colors in the rainbow.
;; Example:
(define RainbowColor-RED "Red")
(define RainbowColor-ORANGE "Orange")
(define RainbowColor-YELLOW "Yellow")
(define RainbowColor-GREEN "Green")
(define RainbowColor-CYAN "Cyan")
(define RainbowColor-BLUE "Blue")
(define RainbowColor-VIOLET "Violet")
;; Template
;; rc-templ : RainbowColor -> ?
(define (rc-templ rc)
  (cond
    [(string=? rc RainbowColor-RED) ...]
    [(string=? rc RainbowColor-ORANGE) ...]
    [(string=? rc RainbowColor-YELLOW) ...]
    [(string=? rc RainbowColor-GREEN) ...]
    [(string=? rc RainbowColor-CYAN) ...]
    [(string=? rc RainbowColor-BLUE) ...]
    [(string=? rc RainbowColor-VIOLET) ...]))

;;! Part B

;; Design a predicate called primary? to determine if a RainbowColor is a primary
;; color (red, yellow, or blue).

;; primary: String -> String
;; Consumes RainbowColor and determines if it is one of the primary colors, "Red", "Yellow", or "Blue"
(check-expect (primary? "Red") "Yes")
(check-expect (primary? "Orange") "No")
(check-expect (primary? "Yellow") "Yes")
(check-expect (primary? "Green") "No")
(check-expect (primary? "Cyan") "No")
(check-expect (primary? "Blue") "Yes")
(check-expect (primary? "Violet") "No")
(define (primary? RainbowColor)
  (cond
    [(string=? RainbowColor "Red") "Yes"]
    [(string=? RainbowColor "Orange") "No"]
    [(string=? RainbowColor "Yellow") "Yes"]
    [(string=? RainbowColor "Green") "No"]
    [(string=? RainbowColor "Cyan") "No"]
    [(string=? RainbowColor "Blue") "Yes"]
    [(string=? RainbowColor "Violet") "No"]))
  

;;! Part C

;; Design a function called next-color that consumes a RainbowColor and produces
;; the next color, where next goes from outside to inside of a rainbow. When
;; applies to the innermost color (violet), it produces the outermost color (red).

;; next-color : String -> String
;; Consumes a RainbowColor and returns the next-color from outside to inside of a rainbow.
(check-expect (next-color "Red") "Orange")
(check-expect (next-color "Orange") "Yellow")
(check-expect (next-color "Yellow") "Green")
(check-expect (next-color "Green") "Cyan")
(check-expect (next-color "Cyan") "Blue")
(check-expect (next-color "Blue") "Violet")
(check-expect (next-color "Violet") "Red")
(define (next-color RainbowColor)
  (cond
    [(string=? RainbowColor "Red") "Orange"]
    [(string=? RainbowColor "Orange") "Yellow"]
    [(string=? RainbowColor "Yellow") "Green"]
    [(string=? RainbowColor "Green") "Cyan"]
    [(string=? RainbowColor "Cyan") "Blue"]
    [(string=? RainbowColor "Blue") "Violet"]
    [(string=? RainbowColor "Violet") "Red"]))

