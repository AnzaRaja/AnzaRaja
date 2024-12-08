;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |Anza CS2500 hw 11|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; Task 7: In a comment at the top of your file, tell us what to run to see your game in action with the following scenario:
;; Run (pipe-fantasy PIPE-FANTASY-0) to play the game.


; Part 2 is at the bottom of this file


;; Part 1

;; Task 1: complete the data design

#|(define-struct starting-pipe [top bot left right])
;; A StartingPipe is a (make-starting-pipe Boolean Boolean Boolean Boolean)
;; Interpretation: A pipe with only one opening. A #true for one of top, bot,
;; left, right indicates an opening in that direction with only one opening
;; possible per pipe.
;; Examples:
(define PIPE-T (make-starting-pipe #true #false #false #false))
(define PIPE-B (make-starting-pipe #false #true #false #false))
(define PIPE-L (make-starting-pipe #false #false #true #false))
(define PIPE-R (make-starting-pipe #false #false #false #true)) |#



(define-struct pipe [top bot left right starting-pipe?])
;; A Pipe is a (make-pipe Boolean Boolean Boolean Boolean Boolean)
;; Interpretation: a pipe with openings in the given directions. A  #true for 
;; one of top, bot, left, right indicates an opening in that direction. A Pipe
;; is a starting-pipe when it has an opening in only one direction.

;; Examples:
(define PIPE-TL (make-pipe #true #false #true #false #false))
(define PIPE-TR (make-pipe #true #false #false #true #false))
(define PIPE-BL (make-pipe #false #true #true #false #false))
(define PIPE-BR (make-pipe #false #true #false #true #false))
(define PIPE-TB (make-pipe #true #true #false #false #false))
(define PIPE-LR (make-pipe #false #false #true #true #false))
(define PIPE-TBLR (make-pipe #true #true #true #true #false))
(define PIPE-T (make-pipe #true #false #false #false #true))
(define PIPE-B (make-pipe #false #true #false #false #true))
(define PIPE-L (make-pipe #false #false #true #false #true))
(define PIPE-R (make-pipe #false #false #false #true #true))
;; Template :
;; pipe-templ : Pipe -> ?
(define (pipe-templ p)
  (... (pipe-top p) ...
       (pipe-bot p) ...
       (pipe-left p) ...
       (pipe-right p) ...
       (pipe-starting-pipe? p) ...))

;; A Pipe is one of
;; - (make-starting-pipe Boolean Boolean Boolean Boolean)
;; - (make-pipe Boolean Boolean Boolean Boolean)
;; Interpretation: Represents a type of Pipe
;;     - (make-starting-pipe top bot left right) is a pipe with only one opening, with
;;       #true in either top, bottom, left, right already placed a the start of a game.
;;     - (make-pipe top bot left right) is a pipe that can be placed by the user during the game.

;; Task 2: Create a list called ALL-PIPES that contains every kind of pipe.

;; A [List-of AllPipes] is one of
;; - empty
;; - (cons list-of-all-pipes [List-of AllPipes])
;; Interpretation: Represents a list of all the pipes.
;; - empty represents a list with no pipes
;; - (cons first rest) represents a list with a _first_ pipe and the _rest_
;; of the pipes
;; Examples
(define ALL-PIPES
  (list
   (make-pipe #true #true #false #false #false)
   (make-pipe #true #false #true #false #false)
   (make-pipe #true #false #false #true #false)
   (make-pipe #false #true #true #false #false)
   (make-pipe #false #true #false #true #false)
   (make-pipe #false #false #true #true #false)
   (make-pipe #true #true #true #true #false)
   (make-pipe #true #false #false #false #false)
   (make-pipe #false #true #false #false #false)
   (make-pipe #false #false #true #false #false)
   (make-pipe #false #false #false #true #false)))

(define ALL-PIPES-2 (cons PIPE-TL (cons PIPE-TR (cons PIPE-BL (cons PIPE-BR (cons PIPE-TB (cons PIPE-LR (cons PIPE-TBLR (cons PIPE-TL
                                (cons PIPE-TR (cons PIPE-BL (cons PIPE-BR (cons PIPE-TB (cons PIPE-LR (cons PIPE-TBLR (cons PIPE-LR
                                (cons PIPE-TBLR (cons PIPE-BR (cons PIPE-TB (cons PIPE-LR (cons PIPE-TBLR (cons PIPE-TL (cons PIPE-TR
                                (cons PIPE-BL (cons PIPE-BR (cons PIPE-TB (cons PIPE-TL (cons PIPE-TR (cons PIPE-BL (cons PIPE-TL
                                (cons PIPE-TR (cons PIPE-BL (cons PIPE-BR (cons PIPE-TB (cons PIPE-LR (cons PIPE-TBLR (cons PIPE-TL
                                (cons PIPE-TR (cons PIPE-BL (cons PIPE-BR (cons PIPE-TB (cons PIPE-LR (cons PIPE-TBLR (cons PIPE-LR
                                (cons PIPE-TR (cons PIPE-BL (cons PIPE-BR (cons PIPE-TB (cons PIPE-LR (cons PIPE-TBLR (cons PIPE-TL
                                (cons PIPE-TR (cons PIPE-BL (cons PIPE-BR (cons PIPE-TB (cons PIPE-LR (cons PIPE-TBLR (cons PIPE-LR
                                (cons PIPE-TBLR (cons PIPE-BR (cons PIPE-TB (cons PIPE-LR (cons PIPE-TBLR (cons PIPE-TL (cons PIPE-TR
                                (cons PIPE-BL (cons PIPE-BR (cons PIPE-TB (cons PIPE-TL (cons PIPE-TR (cons PIPE-BL (cons PIPE-TL
                                (cons PIPE-TR (cons PIPE-BL (cons PIPE-BR (cons PIPE-TB (cons PIPE-LR (cons PIPE-TBLR (cons PIPE-TL
                                (cons PIPE-TR (cons PIPE-BL (cons PIPE-BR (cons PIPE-TB (cons PIPE-LR (cons PIPE-TBLR (cons PIPE-LR
                                (cons PIPE-BR (cons PIPE-TB (cons PIPE-TL empty)))))))))))))))))))))))))))))))))))))))))))))))))))))
                                ))))))))))))))))))))))))))))))))))))

(define PIPE-LIST (cons PIPE-TL (cons PIPE-TR (cons PIPE-BL (cons PIPE-BR (cons PIPE-TB (cons PIPE-LR (cons PIPE-TBLR (cons PIPE-TL
                                (cons PIPE-TR (cons PIPE-BL (cons PIPE-BR empty))))))))))))

;; Task 3: During the game, the player places pipes onto square tiles on the board.
;; Design a function with the following signature and purpose statement:

;; pipe->image: Pipe Integer Integer Boolean -> Image
;; Draws the given pipe on a square tile with length tile-side-length. The width
;; of the pipe is pipe-width. Pipe-width should be less than tile-side-length
;; If filled? then draw the pipe with goo.
(define (pipe->image pipe tile-side-length pipe-width filled? completely-filled? direction) 
  (cond
    [(and (pipe-top pipe) (pipe-bot pipe) (pipe-left pipe) (pipe-right pipe)) (TBLR pipe tile-side-length pipe-width filled? completely-filled? direction)]  
    [(and (pipe-top pipe) (pipe-left pipe)) (TL pipe tile-side-length pipe-width filled?)]    
    [(and (pipe-top pipe) (pipe-right pipe)) (TR pipe tile-side-length pipe-width filled?)]    
    [(and (pipe-bot pipe) (pipe-left pipe)) (BL pipe tile-side-length pipe-width filled?)]    
    [(and (pipe-bot pipe) (pipe-right pipe)) (BR pipe tile-side-length pipe-width filled?)]    
    [(and (pipe-top pipe) (pipe-bot pipe)) (TB pipe tile-side-length pipe-width filled?)]    
    [(and (pipe-left pipe) (pipe-right pipe)) (LR pipe tile-side-length pipe-width filled?)]   
    [(and (pipe-starting-pipe? pipe) (or (pipe-top pipe) (pipe-bot pipe) (pipe-left pipe) (pipe-right pipe)))
     (op-filled? pipe tile-side-length pipe-width)]
         ; deals w starting pipe 
    
    [else (EMPTY-TILE pipe tile-side-length)]))

 ;; OP : Opening-pipe Number Number -> image
;; takes a pipe with one opening and produces and image 
(define (op-filled? pipe tile-side-length pipe-width) 
  (cond
    [(and (boolean=? (pipe-left pipe) #t) (boolean=? (pipe-starting-pipe? pipe) #f)) (place-image/align (rectangle tile-side-length pipe-width "solid" "black")
                     (/ tile-side-length 2) (/ tile-side-length 2) "right" "center"
                     (square tile-side-length "solid" "gray"))]
     [(and (boolean=? (pipe-left pipe) #t) (boolean=? (pipe-starting-pipe? pipe) #t)) (place-image/align (rectangle tile-side-length pipe-width "solid" "Medium Green")
                     (/ tile-side-length 2) (/ tile-side-length 2) "right" "center"
                     (square tile-side-length "solid" "gray"))]
    [(and (boolean=? (pipe-right pipe) #t) (boolean=? (pipe-starting-pipe? pipe) #f)) (place-image/align (rectangle 100 60 "solid" "black")
                     (/ 100 2) (/ 100 2) "left" "center"
                     (square 100 "solid" "gray"))]
    [(and (boolean=? (pipe-right pipe) #t) (boolean=? (pipe-starting-pipe? pipe) #t)) (place-image/align (rectangle 100 60 "solid" "Medium Green")
                     (/ 100 2) (/ 100 2) "left" "center"
                     (square 100 "solid" "gray"))]   
    [(and (boolean=? (pipe-top pipe) #t) (boolean=? (pipe-starting-pipe? pipe) #f)) (place-image/align (rectangle 60 100 "solid" "black")
                     (/ 100 2) (/ 100 2) "center" "bottom"
               (square 100 "solid" "gray"))]
    [(and (boolean=? (pipe-top pipe) #t) (boolean=? (pipe-starting-pipe? pipe) #t)) (place-image/align (rectangle 60 100 "solid" "Medium Green")
                     (/ 100 2) (/ 100 2) "center" "bottom"
               (square 100 "solid" "gray"))]  
    [(and (boolean=? (pipe-bot pipe) #t) (boolean=? (pipe-starting-pipe? pipe) #f)) (place-image/align (rectangle pipe-width tile-side-length "solid" "black")
                     (/ tile-side-length 2) (/ tile-side-length 2) "center" "top"
               (square tile-side-length "solid" "gray"))]
    [(and (boolean=? (pipe-bot pipe) #t) (boolean=? (pipe-starting-pipe? pipe) #t)) (place-image/align (rectangle pipe-width tile-side-length "solid" "Medium Green")
                     (/ tile-side-length 2) (/ tile-side-length 2) "center" "top"
               (square tile-side-length "solid" "gray"))]))


;; TB : Pipe-TB Number Number Boolean -> Image
;; Takes a pipe with a top and bottom opening and produces an image.
(define (TB pipe tile-side-length pipe-width filled?)
  (if filled?
      (place-image (rectangle pipe-width tile-side-length "solid" "green")
                   (/ tile-side-length 2) (/ tile-side-length 2)
                   (square tile-side-length "solid" "gray"))
      (place-image (rectangle pipe-width tile-side-length "solid" "black")
                   (/ tile-side-length 2) (/ tile-side-length 2)
                   (square tile-side-length "solid" "gray"))))

;; LR: Pipe-LR Number Number Boolean -> Image
;; Takes a pipe with a left and right opening and produces an image.
(define (LR pipe tile-side-length pipe-width filled?)
  (if filled?
       (place-image (rectangle tile-side-length pipe-width "solid" "green")
                    (/ tile-side-length 2) (/ tile-side-length 2)
                    (square tile-side-length "solid" "gray"))
       (place-image (rectangle tile-side-length pipe-width "solid" "black")
                    (/ tile-side-length 2) (/ tile-side-length 2)
                    (square tile-side-length "solid" "gray"))))

;; TL: Pipe-TL Number Number Boolean -> Image
;; Takes a pipe with a top and left opening and produces an image.
(define (TL pipe tile-side-length pipe-width filled?)
  (if filled?
      (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "green")
                   (/ tile-side-length 2) (/ tile-side-length 4)
                   (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width "solid" "green")
                                (/ tile-side-length 4) (/ tile-side-length 2)
                                (square tile-side-length "solid" "gray")))
      (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "black")
                   (/ tile-side-length 2) (/ tile-side-length 4)
                   (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width "solid" "black")
                                (/ tile-side-length 4) (/ tile-side-length 2)
                                (square tile-side-length "solid" "gray")))))

;; TR: Pipe-TR Number Number Boolean -> Image
;; Takes a pipe with a top and right opening and produces an image.
(define (TR pipe tile-side-length pipe-width filled?)
  (if filled?
      (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "green")
                   (/ tile-side-length 2) (/ tile-side-length 4)
                   (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width  "solid" "green")
                                (* tile-side-length 0.75) (/ tile-side-length 2)
                                (square tile-side-length "solid" "gray")))
      (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "black")
                   (/ tile-side-length 2) (/ tile-side-length 4)
                   (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width  "solid" "black")
                                (* tile-side-length 0.75) (/ tile-side-length 2)
                                (square tile-side-length "solid" "gray")))))

;; BL: Pipe-BL Number Number Boolean -> Image
;; Takes a pipe with a bottom and left opening and produces an image.
(define (BL pipe tile-side-length pipe-width filled?)
  (if filled?
      (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "green")
                   (/ tile-side-length 2) (* tile-side-length 0.75)
                   (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width "solid" "green")
                                (/ tile-side-length 4) (/ tile-side-length 2)
                                (square tile-side-length "solid" "gray")))
      (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "black")
                   (/ tile-side-length 2) (* tile-side-length 0.75)
                   (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width "solid" "black")
                                (/ tile-side-length 4) (/ tile-side-length 2)
                                (square tile-side-length "solid" "gray")))))

;; BR: Pipe-BR Number Number Boolean -> Image
;; Takes a pipe with a botton and right opening and produces an image.
(define (BR pipe tile-side-length pipe-width filled?)
  (if filled?
      (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "green")
                   (/ tile-side-length 2) (* tile-side-length 0.75)
                   (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width  "solid" "green")
                                (* tile-side-length 0.75) (/ tile-side-length 2)
                                (square tile-side-length "solid" "gray")))
  (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "black")
               (/ tile-side-length 2) (* tile-side-length 0.75)
               (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width  "solid" "black")
                            (* tile-side-length 0.75) (/ tile-side-length 2)
                            (square tile-side-length "solid" "gray")))))

;; TBLR: Pipe-TBLR Number Number Boolean Boolean String-> Image
;; Takes a pipe with a top, boottom, left and right opening and produces an image.
(define (TBLR pipe tile-side-length pipe-width filled? completely-filled? direction)
  (if filled?
      (if (not completely-filled?)
               (if (or (string=? direction "right") (string=? direction "left"))
                   (place-image (rectangle tile-side-length pipe-width "solid" "green")
                                (/ tile-side-length 2) (/ tile-side-length 2)
                                (place-image (rectangle pipe-width tile-side-length "solid" "black")
                                (/ tile-side-length 2) (/ tile-side-length 2)
                                (square tile-side-length "solid" "gray")))
                     (place-image (rectangle pipe-width tile-side-length "solid" "green")
                   (/ tile-side-length 2) (/ tile-side-length 2)
                   (place-image (rectangle tile-side-length pipe-width "solid" "black")
                                (/ tile-side-length 2) (/ tile-side-length 2)
                                (square tile-side-length "solid" "gray"))))
       (place-image (rectangle pipe-width tile-side-length "solid" "green")
                   (/ tile-side-length 2) (/ tile-side-length 2)
                   (place-image (rectangle tile-side-length pipe-width "solid" "green")
                                (/ tile-side-length 2) (/ tile-side-length 2)
                                (square tile-side-length "solid" "gray"))))
      (place-image (rectangle pipe-width tile-side-length "solid" "black")
                   (/ tile-side-length 2) (/ tile-side-length 2)
                   (place-image (rectangle tile-side-length pipe-width "solid" "black")
                                (/ tile-side-length 2) (/ tile-side-length 2)
                                (square tile-side-length "solid" "gray")))))

;; EMPTY-TILE : Pipe Number -> Image
;; Takes a pipe with all openings #false and produces an empty tile.
(define (EMPTY-TILE pipe tile-side-length)
  (square tile-side-length "outline" "black"))







;;;;;;;;;;;;;
;; Part 2  ;;
;;;;;;;;;;;;;






;; Task 4: Complete a data design called Grid that represents a grid.
;; You should construct several examples of varying sizes and with different pipes places on them.

;; Recommendation 2: A better approach is to only represent the list of placed pipes.
;; So, a blank grid would be represented by the empty list. Thus each item in the list must represent both a pipe
;; and its coordinates on the grid. (This requires an auxiliary data definition for a pipe with its coordinates.)


;COMPLETE DESIGN RECIPE FOR STRUCTS

(define-struct tile [pipe x y filled? completely-filled? direction]) 
;; A tile is a (make-tile Pipe Number Number Boolean Boolean String)
;; Interpretation : Represents a single tile with a specific pipe and its
;; position represented by x and y coordinates with info if its filled 
;; Examples:
(define TILE-1 (make-tile PIPE-TB 3 2 #f #f "up"))
(define TILE-2 (make-tile PIPE-BR 6 1 #f #f "down"))
(define TILE-3 (make-tile PIPE-LR 2 5 #t #t "right"))
;; Template :
;; tile-templ : Tile -> ?
(define (tile-templ t)
  (... (pipe-templ (tile-pipe t) ...
              (tile-x t) ...
              (tile-y t) ...
              (filled? t) ...
              (completely-filled?)
              (direction))))
  
  

(define-struct grid [dim lot]) 
;; A grid is a (make-grid Number [List-of Tile])
;; Interpretation : A grid with a number representing its dimensions and
;; a [List-of Tile] representing a single tile with its openinings and
;; x and y coordinates.


;; grid : Number [List-of Tile] -> Grid
;; Represents a grid with given dimension and a [List-of Tile] 
;; Examples:
(define GRID-0 (make-grid 10 '()))
(define GRID-1 (make-grid 14 (list (make-tile PIPE-TB 10 2 #f #f "down") (make-tile PIPE-TL 10 2 #f #f "left"))))
(define GRID-2 (make-grid 15 (list (make-tile PIPE-TBLR 6 12 #f #f "down"))))
(define GRID-3 (make-grid 15 (list (make-tile PIPE-TBLR 3 10 #f #f "down"))))
(define GRID-4 (make-grid 90 (list (make-tile PIPE-TBLR 50 50 #f #f "down"))))
(define GRID-5 (make-grid 45 (list (make-tile PIPE-TBLR 34 43 #f #f "down"))))
(define GRID-6 (make-grid 32 (list (make-tile PIPE-TBLR 7 4 #f #f "down"))))
(define GRID-7 (make-grid 61 (list (make-tile PIPE-TBLR 6 60 #f #f "down"))))
(define GRID-8 (make-grid 14 (list (make-tile PIPE-T 10 2 #t #t "left") (make-tile PIPE-BR 11 2 #f #f "right") (make-tile PIPE-TB 6 5 #f #f "down"))))
;; Template :
;; grid-templ : Grid -> ?
(define (grid-templ g)
  (... (grid-dim g) ...
       (lot-templ (grid-lot g))))



;; Task 5: Create an example that represents an empty 7 × 7 grid called STARTING-GRID.
(define STARTING-GRID-0 (make-grid 7 '()))
(define STARTING-GRID-T (make-grid 7 (cons (make-tile PIPE-T 2 1 #t #f "up") '())))
(define STARTING-GRID-B (make-grid 7 (cons (make-tile PIPE-B 2 2 #t #f "down") '())))
(define STARTING-GRID-L (make-grid 7 (cons (make-tile PIPE-L 2 3 #t #f "left") '())))
(define STARTING-GRID-R (make-grid 7 (cons (make-tile PIPE-R 2 4 #t #f "right") '())))



;; Task 6: Complete the following function designs (do not modify the signatures):

;; last : [List-of x] -> X
;; Returns the last item in the list.
(define (last lot)
  (cond
    [(empty? lot) '()]
    [(and (cons? lot) (empty? (rest lot))) (first lot)]
    [else (last (rest lot))]))

;; Task 4: Modify your place-pipe-on-grid function to implement this feature: if the user tries to
;; place an incoming pipe on a pipe that already has goo in it, then the pipe should not be placed.
          
;; place-pipe: Grid Pipe Integer Integer -> Grid
;; Places the pipe on the grid at the given row and column. We assume that the
;; row and column are valid positions on the grid.
          
(check-expect (place-pipe GRID-1 PIPE-TB 4 5)
              (make-grid
 14
 (list
  (make-tile (make-pipe #true #true #false #false #false) 10 2 #false #false "down")
  (make-tile (make-pipe #true #false #true #false #false) 10 2 #false #false "left")
  (make-tile (make-pipe #true #true #false #false #false) 4 5 #false #false "empty"))))

(check-expect (place-pipe GRID-0 PIPE-TL 8 1)
              (make-grid 10
                         (list
                          (make-tile (make-pipe #true #false #true #false #false) 8 1 #false #false "empty"))))

(check-expect (place-pipe GRID-5 PIPE-TBLR 40 32)
              (make-grid 45
                         (list
                          (make-tile (make-pipe #true #true #true #true #false) 34 43 #false #false "down")
                          (make-tile (make-pipe #true #true #true #true #false) 40 32 #false #false "empty"))))

(define (place-pipe grid pipe row col)
  (local [;;
          ;;
          (define (pipe-filled? x y lot)
            (cond
              [(empty? lot) #false]
              [(cons? lot) (if (and (= (tile-x (first lot)) x) (= (tile-y (first lot)) y)) 
                               (tile-filled? (first lot))
                               (pipe-filled? x y (rest lot)))]))]
    (if (pipe-filled? row col (grid-lot grid))
        grid
        (make-grid (grid-dim grid)
             (if (= (length (filter (λ (t) (and (= (tile-x t) row) (= (tile-y t) col))) (append (grid-lot grid) (cons (make-tile pipe row col #f #f "empty") empty)))) 1)
                 (append (grid-lot grid) (cons (make-tile pipe row col #f #f "empty") empty))
                 (append (filter (λ (t) (if (and (= (tile-x t) row) (= (tile-y t) col))
                                            #f
                                            #t)) (grid-lot grid))
                                 (cons (last (filter (λ (t) (and (= (tile-x t) row) (= (tile-y t) col))) (append (grid-lot grid) (cons (make-tile pipe row col #f #f "empty") empty)))) empty))))))) ; hard wired an empty boolean
;(append (grid-lot grid) (cons (make-tile pipe row col #f #f "empty") empty)))
#;(define (place-pipe grid pipe row col)
  (cond
    [(empty? grid-lot) (make-grid (grid-dim grid)
                                  (cons (make-tile pipe row col) (grid-lot grid )))]
    [(and (cons? (grid-lot grid)) (= (tile-x (first (grid-lot grid))) row) (= (tile-y (first (grid-lot grid))) pipe)) (make-grid (grid-dim grid)
                                                                 (cons (make-tile pipe row col) (place-pipe (rest (grid-lot grid )) pipe row col)))]))
    
                                                      ;(place-pipe (rest (grid-lot grid) pipe row col)))]))
(define (string-equals? s list)
  (map (filter (λ (s) (string=? s)) list) list))
  
;; pipe-at: Grid Integer Integer -> [Optional Pipe]
;; Produces the pipe at the given row and column, or #false if that position is
;; is blank. We assume that the row and column are valid positions on the grid.
(check-expect (pipe-at GRID-3 6 2) #false)
(check-expect (pipe-at GRID-5 34 43) (make-pipe #true #true #true #true #false))
(check-expect (pipe-at GRID-1 6 5) #false)
(check-expect (pipe-at GRID-3 4 1) #false)
(check-expect (pipe-at GRID-7 6 60) (make-pipe #true #true #true #true #false))

(define (pipe-at grid row col)
  (cond
    [(empty? (grid-lot grid)) #false]
    [(cons? (grid-lot grid)) (if (tile-equal? (first (grid-lot grid)) row col) (tile-pipe (first (grid-lot grid)))
                                 (pipe-at (make-grid (grid-dim grid) (rest (grid-lot grid))) row col))]))


;; tile-equal? : Tile Number Number -> Boolean
;; Returns true if tile row and column are equal to given row and column.
(check-expect (tile-equal? TILE-1 5 2) #false)
(check-expect (tile-equal? TILE-1 6 2) #false)
(check-expect (tile-equal? TILE-3 2 5) #true)
(check-expect (tile-equal? TILE-2 6 1) #true)

(define (tile-equal? t row col)
  (and (= row (tile-x t))
       (= col (tile-y t))))


;; Task 7: Complete the following function design.
;; Do not modify its signature, and you do not need to write check-expects for it:

;; grid->image: Grid Integer Integer -> Image
;; Draws the grid of pipes. Every tile should be a square with side length
;; tile-side-length and every pipe should have width pipe-width.
;(define GRID-1 (make-grid 14 (list (make-tile PIPE-TL 10 2) (make-tile PIPE-TB 6 5))))
 
(define (grid->image grid tile-side-length pipe-width gooflow gamestate)  
  (place-pipes (grid-lot grid) tile-side-length (blank-grid (grid-dim grid) (grid-dim grid) tile-side-length) pipe-width gooflow gamestate))





                              ;(grid->image (make-grid (grid-dim grid) (rest (grid-lot grid))) tile-side-length pipe-width)]))

;; place-pipes : [List-of Tile] Number Image Number -> Image
;; Produces an image of the rest of the pipes on top of the current image.

#;(check-expect (place-pipes (list TILE-1) 40 (grid->image GRID-0 40 15 #f) 15 #false)
              (place-image
               (place-image
                (rectangle 15 40 "solid" "black")
                (/ 40 2) (/ 40 2)
                (square 40 "solid" "gray"))
               100 60
               (grid->image GRID-0 40 15 #f)))

#;(check-expect (place-pipes (list TILE-1 TILE-2) 40 (grid->image GRID-0 40 15 #f) 15 #false)
              (place-image
               (place-image (rectangle 15 (/ 40 2) "solid" "black")
               (/ 40 2) (* 40 0.75)
               (place-image (rectangle (+ 15 (/ 40 2)) 15  "solid" "black")
                            (* 40 0.75) (/ 40 2)
                            (square 40 "solid" "gray")))
               220 20
              (place-image
               (place-image
                (rectangle 15 40 "solid" "black")
                (/ 40 2) (/ 40 2)
                (square 40 "solid" "gray"))
               100 60
               (grid->image GRID-0 40 15 #f))))

#;(check-expect (place-pipes (list TILE-1 TILE-2 TILE-3) 40 (grid->image GRID-0 40 15 #f) 15 #false)
              (place-image
               (place-image (rectangle 40 15 "solid" "black")
                    (/ 40 2) (/ 40 2)
                    (square 40 "solid" "gray"))
               60 180
               (place-image
               (place-image (rectangle 15 (/ 40 2) "solid" "black")
               (/ 40 2) (* 40 0.75)
               (place-image (rectangle (+ 15 (/ 40 2)) 15  "solid" "black")
                            (* 40 0.75) (/ 40 2)
                            (square 40 "solid" "gray")))
               220 20
              (place-image
               (place-image
                (rectangle 15 40 "solid" "black")
                (/ 40 2) (/ 40 2)
                (square 40 "solid" "gray"))
               100 60
               (grid->image GRID-0 40 15 #f)))))              

(define (place-pipes list-of-tiles tile-side-length image pipe-width filled? gs)
  (local [;;
          ;;
          (define (pipe-filled? x y lot)
            (cond
              [(empty? lot) #false]
              [(cons? lot) (if (and (= (tile-x (first lot)) x) (= (tile-y (first lot)) y)) 
                               (tile-filled? (first lot))
                               (pipe-filled? x y (rest lot)))]))
          ;; pipe-fully-filled? : Number Number [List-of Tile] -> Boolean
          ;; 
          (define (pipe-fully-filled? x y lot)
            (local [;; pipe=? : Tile Tile -> Boolean
                    ;; Determines whether two tiles are equal to each other
                    (define (pipe=? tile-1 tile-2)
                      (if (and (boolean=? (pipe-top tile-1) (pipe-top tile-2)) (boolean=? (pipe-bot tile-1) (pipe-bot tile-2))
                               (boolean=? (pipe-left tile-1) (pipe-left tile-2)) (boolean=? (pipe-right tile-1) (pipe-right tile-2))
                               (boolean=? (pipe-starting-pipe? tile-1) (pipe-starting-pipe? tile-2)))
                          #true
                          #false))]
              (cond
                [(empty? lot) #false]
                [(cons? lot) (if (and (and (= (tile-x (first lot)) x) (= (tile-y (first lot)) y)) (pipe=? (tile-pipe (first lot)) PIPE-TBLR)) 
                                 (tile-completely-filled? (first lot))
                                 (pipe-fully-filled? x y (rest lot)))])))
          (define (pipe-goo-direction x y lot)
            (cond
              [(empty? lot) #false]
              [(cons? lot) (if (and (= (tile-x (first lot)) x) (= (tile-y (first lot)) y)) 
                               (tile-direction (first lot))
                               (pipe-goo-direction x y (rest lot)))]))]
    
    (cond
      [(empty? list-of-tiles) image]
      [(cons? list-of-tiles) (place-pipes (rest list-of-tiles) tile-side-length
                                          (place-image
                                           (pipe->image (tile-pipe (first list-of-tiles)) tile-side-length pipe-width
                                                        (pipe-filled? (tile-x (first list-of-tiles))
                                                                      (tile-y (first list-of-tiles))
                                                                      list-of-tiles)
                                                        (pipe-fully-filled? (tile-x (first list-of-tiles))
                                                                            (tile-y (first list-of-tiles))
                                                                            list-of-tiles)
                                                        (pipe-goo-direction (tile-x (first list-of-tiles))
                                                                            (tile-y (first list-of-tiles))
                                                                            (goo-flow-path (gamestate-gf gs))))
                                           (- (* tile-side-length (tile-x (first list-of-tiles))) (/ tile-side-length 2))
                                           (- (* tile-side-length (tile-y (first list-of-tiles))) (/ tile-side-length 2))
                                           image) pipe-width filled? gs)])))

#;(define (last lot)
            (cond
              [(empty? lot) '()]
              [(and (cons? lot) (empty? (rest lot))) (first lot)]
              [else (last (rest lot))]))
;; single-row : PositiveInteger Number -> Image
;; Produces a row of squares of the given number and dimensions.
(check-expect (single-row 4 30) (single-row 4 30))
(check-expect (single-row 6 20) (single-row 6 20))
(check-expect (single-row 10 50) (single-row 10 50))

(define (single-row r tile-side-length)
  (if (= r 1)
      (square tile-side-length "outline" "black")
      (beside
       (square tile-side-length "outline" "black") (single-row (- r 1) tile-side-length))))


;; blank-grid : PositiveInteger PositiveInteger Number -> Image
;; Returns an image of a grid with n amount of rows and c amount of columns.
(check-expect (blank-grid 5 5 30) (blank-grid 5 5 30))
(check-expect (blank-grid 10 10 50) (blank-grid 10 10 50))
(check-expect (blank-grid 40 40 20) (blank-grid 40 40 20))

(define (blank-grid r c tile-side-length)
  (if (= c 1) (single-row r tile-side-length)
      (above
       (single-row r tile-side-length) (blank-grid r (- c 1) tile-side-length))))

;;  Task 3 --

;; A direction is one of
;; "up" - where the direction is going up
;; "down" - where the direction is going down
;; "left" - where the direction is going left
;; "right" - right where the direction is going right
;; "error" - if hits a boundary, an empty cell, or 
;; Interpretation: the direction of where the gooflow is going
;; does not track the shape of a pipe
(define UP "up")
(define DOWN "down")
(define LEFT "left")
(define RIGHT "right")
(define (direction-temp dt) 
  (... (cond
         [(string=? dt UP) ...]
         [(string=? dt DOWN) ...]
         [(string=? dt LEFT) ...]
         [(string=? dt RIGHT) ...])))

(define TILE-4 (make-tile PIPE-TB 3 2 #t #f "down"))
(define TILE-5 (make-tile PIPE-LR 3 3 #t #f "right"))
(define TILE-6 (make-tile PIPE-LR 3 4 #t #f "right"))
(define TILE-7 (make-tile PIPE-R 8 1 #f #f "right"))
(define TILE-8 (make-tile PIPE-L 9 9 #f #f "left"))

;; Task 3: Goo flows through the pipes on the grid, starting from the starting pipe.
;; The starting pipe is considered to have goo from the beginning. The goo continues
;; to propagate in the direction of the opening until it reaches either:
;; - An empty cell,
;; - The boundary of the grid, or
;; - A pipe that does not have an opening towards the direction of the flow.

;; Design data called GooFlow that represents the path taken by the goo and the direction
;; in which it is flowing. You can modify existing data if you wish, but it isn’t necessary to do so.
       
(define-struct goo-flow [path direction x y])
;; GooFlow is a (make-goo-flow [List-of Tiles] Direction Number Number)
;; Interpretation: Represents the flow of the goo where the path
;; represents the List-of Pipes, that are on the grid, with a fixed
;; starting pipe and direction is one of top, bottom, left,
;; or right, depending on the pipe opening.
;; x represents the row and y represents the column of the GooFlow.
;; Examples:
(define GOO-FLOW-1 (make-goo-flow (list TILE-1 TILE-2) DOWN 3 4))
(define GOO-FLOW-2 (make-goo-flow (list TILE-6 TILE-3 TILE-1) UP 4 5))
(define GOO-FLOW-3 (make-goo-flow (list TILE-7 TILE-2 TILE-4) RIGHT 4 5))
(define GOO-FLOW-4 (make-goo-flow (list TILE-8 TILE-4 TILE-5) LEFT 4 3))
;; Template
;; goo-flow-templ : GooFlow -> ?
(define (goo-flow-templ gf)
  (... (lot-templ (goo-flow-path gf))
       (direction-temp (goo-flow-direction gf)) ...))

#|;; GooFlow is a (make-goo-flow [List-of Tile] String)
;; Interpretation: tack the gooflow and represent next direction
(define GOO-FLOW-1 (make-goo-flow (list TILE-1 TILE-2) DOWN))
(define GOO-1 (make-goo-flow (list TILE-4 TILE-5 TILE-6) UP))
(define GOO-2 (make-goo-flow (list TILE-4 TILE-5 TILE-6) RIGHT))
(define GOO-3 (make-goo-flow (list TILE-4 TILE-5 TILE-6) DOWN))
(define (goo-flow-temp gft)
  (... (tile-templ (goo-glow-path gft)) 
       (direction-temp (goo-flow-direction gft)))) |#

;; Part 3: Game Interactions

;; Task 8: Complete a data design called GameState.
;; For now, a game should have a grid and a list of “incoming pipes”
;; that may appear when the player clicks on a grid cell. In a complete game,
;; the pipes are generated randomly and there is an infinite supply of pipes.
;; However, for now, you’ll have a fixed list of incoming pipes.

; (define-struct pipe [top bot left right])(define STARTING-PIPE-1 (make-pipe #true #false #false #false #true))

(define STARTING-GRID-1 (make-grid 7 (list (make-tile PIPE-R 2 3 #t #f "right")))) 
(define-struct gamestate [grid in-pipes tile-side-length pipe-width gf replaced-pipes time]) 
;; A GameState is a (make-gamestate Grid [List-of Pipes] Number Number (make-goo-flow [List-of Tile] String Integer))
;; Interpretation: A GameState represents the state of the game where:
;; - grid - is what the grid currently looks like
;; - in-pipes - is the list of incoming pipes
;; - replaced-pipes is a number keeping track of how many pipes have been replaced.
;; - time is a number that sets off goopropagate 
;; Examples:

(define GAME-STATE-0 (make-gamestate
                      STARTING-GRID-1
                      PIPE-LIST 100 60 GOO-FLOW-1 0 140))

 
   

(define GAME-STATE-1 (make-gamestate
                      GRID-1
                      (cons PIPE-BR (cons PIPE-LR (cons PIPE-TB empty))) 30 15 GOO-FLOW-1 2 30))
(define GAME-STATE-2 (make-gamestate
                      GRID-2
                      (cons PIPE-TL (cons PIPE-TBLR empty)) 25 15 GOO-FLOW-1 6 10))
(define GAME-STATE-3 (make-gamestate
                      GRID-3
                      (cons PIPE-TR (cons PIPE-TB (cons PIPE-BR (cons PIPE-TL
                                    (cons PIPE-BL (cons PIPE-TR (cons PIPE-LR
                                    (cons PIPE-TBLR (cons PIPE-TB (cons PIPE-TBLR (cons PIPE-TB (cons PIPE-LR empty)))))))))))) 40 20 GOO-FLOW-1 0 15))
(define GAME-STATE-4 (make-gamestate
                      GRID-1
                      empty 30 15 GOO-FLOW-1 1 200))



;; Template:
;; gs-templ : GameState -> ?
(define (gs-templ gs)
  (... (grid-templ (gamestate-grid gs)) ...
       (lop-templ (gamestate-in-pipes gs)) ...
       (gamestate-tile-side-length gs) ...
       (gamestate-pipe-width gs) ...))
(define a "Medium Pink")
;; A [List-of Pipes] is one of:
;; empty
;; (cons Pipe [List-of Pipes])
;; Represents a list of incoming pipes
(define LOP-0 empty)
(define LOP-1 (list PIPE-TL PIPE-BL PIPE-TR PIPE-LR PIPE-TBLR PIPE-TB PIPE-TBLR PIPE-TB PIPE-LR))
;; Template:


;; lop-templ
(define (lop-templ lop)
  (cond
    [(empty? lop) ...]
    [(cons? lop) (... (pipe-templ (first lop) ...)
                 (lop-templ (rest lop)) ...)]))

(define DISPLAY 5)
(define EMPTY-SPACE-SQUARE (square 20 "solid" "white"))

;; draw-grid : Gamestate -> Image
;; draws the current gamestate
(define (draw-grid gs)
  (above/align "middle" (beside (grid->image (gamestate-grid gs) 
                (gamestate-tile-side-length gs)
                (gamestate-pipe-width gs)
                #false gs)
         EMPTY-SPACE-SQUARE 
         (p-placement//draw DISPLAY
                            (gamestate-tile-side-length gs)
                            (gamestate-pipe-width gs) 
                            (gamestate-in-pipes gs)))
               (text (number->string (get-score gs)) 100 "black")))
   

;; p-placement//draw : Natural Natural Natural [List-of Pipes] -> Image
;; Purpose: draws and places pipes on gamestate
(define (p-placement//draw inc-pipes tile-length pipe-width lop)
  (local
    [(define EMPTY-SQ (square tile-length "outline" "medium pink"))]
  (cond
    [(and (empty? lop) (= 0 (- inc-pipes 1)) ) EMPTY-SQ]
    [(and (empty? lop) (not (= 0 (- inc-pipes 1))))
     (above EMPTY-SQ
             (p-placement//draw (- inc-pipes 1) tile-length pipe-width empty))]
    [(and (cons? lop) (= 0 (- inc-pipes 1))) 
     (pipe->image (first lop) tile-length pipe-width #false #f "empty")]
    [(and (cons? lop) (not (= 0 (- inc-pipes 1))))
     (above (pipe->image (first lop) tile-length pipe-width #false #f "empty")
             (p-placement//draw (- inc-pipes 1) tile-length pipe-width (rest lop)))])))

;; Task 6: Write an on-tick handler for the big-bang

;; countdown : GameState ->

(check-expect (countdown GAME-STATE-0)
              (make-gamestate
               (make-grid 7 (list (make-tile (make-pipe #false #false #false #true #true) 2 3 #true #false "right")))
               (list
                (make-pipe #true #false #true #false #false)
                (make-pipe #true #false #false #true #false)
                (make-pipe #false #true #true #false #false)
                (make-pipe #false #true #false #true #false)
                (make-pipe #true #true #false #false #false)
                (make-pipe #false #false #true #true #false)
                (make-pipe #true #true #true #true #false)
                (make-pipe #true #false #true #false #false)
                (make-pipe #true #false #false #true #false)
                (make-pipe #false #true #true #false #false)
                (make-pipe #false #true #false #true #false))
               100
               60
               (make-goo-flow
                (list (make-tile (make-pipe #true #true #false #false #false) 3 2 #false #false "up") (make-tile (make-pipe #false #true #false #true #false) 6 1 #false #false "down"))
                "down"
                3
                4)
               0
               139))

(check-expect (countdown GAME-STATE-1)
              (make-gamestate
               (make-grid 14 (list (make-tile (make-pipe #true #true #false #false #false) 10 2 #false #false "down") (make-tile (make-pipe #true #false #true #false #false) 10 2 #false #false "left")))
               (list (make-pipe #false #true #false #true #false) (make-pipe #false #false #true #true #false) (make-pipe #true #true #false #false #false))
               30
               15
               (make-goo-flow
                (list (make-tile (make-pipe #true #true #false #false #false) 3 2 #false #false "up") (make-tile (make-pipe #false #true #false #true #false) 6 1 #false #false "down"))
                "down"
                3
                4)
               2
               29))

(check-expect (countdown GAME-STATE-2)
              (make-gamestate
               (make-grid 15 (list (make-tile (make-pipe #true #true #true #true #false) 6 12 #false #false "down")))
               (list (make-pipe #true #false #true #false #false) (make-pipe #true #true #true #true #false))
               25
               15
               (make-goo-flow
                (list (make-tile (make-pipe #true #true #false #false #false) 3 2 #false #false "up") (make-tile (make-pipe #false #true #false #true #false) 6 1 #false #false "down"))
                "down"
                3
                4)
               6
               9))
                     
(define (countdown gs)
 (local [;;
          ;;
          (define (num-plus-pipes tile lot)
            (cond
              [(empty? lot) 0]
              [(cons? lot) (if (and (= (tile-x tile) (tile-x (first lot))) (= (tile-y tile) (tile-y (first lot))))
                               (+ 1 (num-plus-pipes tile (rest lot)))
                               (num-plus-pipes tile (rest lot)))]))
         ;; pipe=? : Tile Tile -> Boolean
          ;; Determines whether two tiles are equal to each other
          (define (pipe=? tile-1 tile-2)
            (if (and (boolean=? (pipe-top tile-1) (pipe-top tile-2)) (boolean=? (pipe-bot tile-1) (pipe-bot tile-2))
                     (boolean=? (pipe-left tile-1) (pipe-left tile-2)) (boolean=? (pipe-right tile-1) (pipe-right tile-2))
                     (boolean=? (pipe-starting-pipe? tile-1) (pipe-starting-pipe? tile-2)))
                #true
                #false))
         ;; tile-in-list : Tile [List-of Tiles] -> Boolean
          ;; Is a pipe in the incoming list
          (define (tile-in-list tile lot)
            (cond
              [(empty? lot) #false]
              [(cons? lot) (if (and (and (= (tile-x tile) (tile-x (first lot))) (= (tile-y tile) (tile-y (first lot)))) (pipe=? (tile-pipe (first lot)) (tile-pipe tile)))
                               #true
                               (tile-in-list tile (rest lot)))]))
         ;; Produces a new list of pipes and determines if it has goo
          (define (goo-list gf grid)
            (cond
              [(empty? (grid-lot grid)) empty]
              [(cons? (grid-lot grid)) (if (tile-in-list (first (grid-lot grid)) (goo-flow-path gf))
                                           (if (> (num-plus-pipes (first (grid-lot grid)) (goo-flow-path gf)) 1)
                                               (cons (make-tile (tile-pipe (first (grid-lot grid)))
                                                                (tile-x (first (grid-lot grid))) (tile-y (first (grid-lot grid)))
                                                                #true #true (tile-direction (first (grid-lot grid)))) (goo-list gf (make-grid (grid-dim grid) (rest (grid-lot grid)))))
                                               (cons (make-tile (tile-pipe (first (grid-lot grid)))
                                                                (tile-x (first (grid-lot grid))) (tile-y (first (grid-lot grid)))
                                                                #true #false (tile-direction (first (grid-lot grid)))) (goo-list gf (make-grid (grid-dim grid) (rest (grid-lot grid))))))
                                           (cons (make-tile (tile-pipe (first (grid-lot grid)))
                                                                (tile-x (first (grid-lot grid))) (tile-y (first (grid-lot grid)))
                                                                #false #false (tile-direction (first (grid-lot grid)))) (goo-list gf (make-grid (grid-dim grid) (rest (grid-lot grid))))))]))]
   (cond
     [(> (gamestate-time gs) 0) (make-gamestate (gamestate-grid gs) (gamestate-in-pipes gs) (gamestate-tile-side-length gs)
                                               (gamestate-pipe-width gs) (gamestate-gf gs) (gamestate-replaced-pipes gs) (- (gamestate-time gs) 1))]
     [(= (gamestate-time gs) 0) (make-gamestate (make-grid (grid-dim (gamestate-grid gs))
                                                          (goo-list (grid-goo-propagate (gamestate-gf gs) (gamestate-grid gs)) (gamestate-grid gs)))
                                               (gamestate-in-pipes gs) (gamestate-tile-side-length gs) (gamestate-pipe-width gs)
                                               (grid-goo-propagate (gamestate-gf gs) (gamestate-grid gs)) (gamestate-replaced-pipes gs) 28)]
     [else gs])))




;; original -- 
#; (define (draw-grid gs)
  (grid->image (gamestate-grid gs)
                (gamestate-tile-side-length gs)
                (gamestate-pipe-width gs)
                #false))
;; goo propagate for task 9 is already defined at line 872, BUT NOT IMPLEMENTED
;; task 9 is done. at lines 936 and 937





;; Task 9: Complete the following function design:
;; place-pipe-on-click : GameState Integer Integer MouseEvent -> GameState`
;; If the user clicks on a tile and there are incoming pipes available, places
;; the next incoming pipe on that tile. If no pipes are available, does nothing.

(define (place-pipe-on-click gs x y me)
  (local [;; pipe=? : Tile Tile -> Boolean
          ;; Determines whether two tiles are equal to each other
          (define (pipe=? tile-1 tile-2)
            (if (and (boolean=? (pipe-top tile-1) (pipe-top tile-2)) (boolean=? (pipe-bot tile-1) (pipe-bot tile-2))
                     (boolean=? (pipe-left tile-1) (pipe-left tile-2)) (boolean=? (pipe-right tile-1) (pipe-right tile-2))
                     (boolean=? (pipe-starting-pipe? tile-1) (pipe-starting-pipe? tile-2)))
                #true
                #false))

          ;; tile-in-list : Tile [List-of Tiles] -> Boolean
          ;; Is a tile in the incoming list
          (define (tile-in-list tile lot)
            (cond
              [(empty? lot) #false]
              [(cons? lot) (if (and (and (= (tile-x tile) (tile-x (first lot))) (= (tile-y tile) (tile-y (first lot)))) (pipe=? (tile-pipe (first lot)) (tile-pipe tile)))
                               #true
                               (tile-in-list tile (rest lot)))]))
          ;; pipe-in-list : Pipe [List-of Tiles] -> Boolean
          ;; Is a pipe in the incoming list
          (define (pipe-in-list pipe lot)
            (cond
              [(empty? lot) #false]
              [(cons? lot) (if (pipe=? (tile-pipe (first lot)) pipe)
                               #true
                               (pipe-in-list pipe (rest lot)))]))
          ;; num-plus-pipes : Tile [List-of Tile] -> 
          ;; 
          (define (num-plus-pipes tile lot)
            (cond
              [(empty? lot) 0]
              [(cons? lot) (if (and (= (tile-x tile) (tile-x (first lot))) (= (tile-y tile) (tile-y (first lot))))
                               (+ 1 (num-plus-pipes tile (rest lot)))
                               (num-plus-pipes tile (rest lot)))]))

          ;; goo-list : GooFlow Grid -> [List-of Tiles]
          ;; Produces a new list of pipes and determines if it has goo
          (define (goo-list gf grid)
            (cond
              [(empty? (grid-lot grid)) empty]
              [(cons? (grid-lot grid)) (if (tile-in-list (first (grid-lot grid)) (goo-flow-path gf))
                                           (if (> (num-plus-pipes (first (grid-lot grid)) (goo-flow-path gf)) 1)
                                               (cons (make-tile (tile-pipe (first (grid-lot grid)))
                                                                (tile-x (first (grid-lot grid))) (tile-y (first (grid-lot grid)))
                                                                #true #true (tile-direction (first (grid-lot grid)))) (goo-list gf (make-grid (grid-dim grid) (rest (grid-lot grid)))))
                                               (cons (make-tile (tile-pipe (first (grid-lot grid)))
                                                                (tile-x (first (grid-lot grid))) (tile-y (first (grid-lot grid)))
                                                                #true #false (tile-direction (first (grid-lot grid)))) (goo-list gf (make-grid (grid-dim grid) (rest (grid-lot grid))))))
                                           (cons (make-tile (tile-pipe (first (grid-lot grid)))
                                                                (tile-x (first (grid-lot grid))) (tile-y (first (grid-lot grid)))
                                                                #false #false (tile-direction (first (grid-lot grid)))) (goo-list gf (make-grid (grid-dim grid) (rest (grid-lot grid))))))]))]
          
    
     (if (string=? me "button-down")
      (cond
        [(empty? (gamestate-in-pipes gs)) (make-gamestate (make-grid (grid-dim (gamestate-grid gs)) (goo-list (grid-goo-propagate (gamestate-gf gs) (gamestate-grid gs)) (gamestate-grid gs)))
                                                          (gamestate-in-pipes gs)
                                                          (gamestate-tile-side-length gs) (gamestate-pipe-width gs)
                                                          (gamestate-gf gs)
                                                          (gamestate-replaced-pipes gs) (gamestate-time gs))]
        [(cons? (gamestate-in-pipes gs))
         (make-gamestate
          (place-pipe 
           (gamestate-grid gs)
           (first (gamestate-in-pipes gs))
           (cell-index x (gamestate-tile-side-length gs))
           (cell-index y (gamestate-tile-side-length gs)))
          (if (pipe-in-list (first (gamestate-in-pipes gs)) (grid-lot (place-pipe
                                                            (gamestate-grid gs)
                                                            (first (gamestate-in-pipes gs))
                                                            (cell-index x (gamestate-tile-side-length gs)) (cell-index y (gamestate-tile-side-length gs)))))
              (rest (gamestate-in-pipes gs))
              (gamestate-in-pipes gs))
          (gamestate-tile-side-length gs)
          (gamestate-pipe-width gs)
          (gamestate-gf gs)
          (length (pipes-replaced (place-pipe 
           (gamestate-grid gs)
           (first (gamestate-in-pipes gs))
           (cell-index x (gamestate-tile-side-length gs))
           (cell-index y (gamestate-tile-side-length gs)))))
          (gamestate-time gs))])   
      gs)))

#;[(cons? (gamestate-in-pipes gs))
         (make-gamestate
          (place-pipe 
           (gamestate-grid gs)
           (first (gamestate-in-pipes gs))
           (cell-index x (gamestate-tile-side-length gs))
           (cell-index y (gamestate-tile-side-length gs)))
          (rest (gamestate-in-pipes gs))
          (gamestate-tile-side-length gs)
          (gamestate-pipe-width gs)
          (gamestate-gf gs)
          (length (pipes-replaced (place-pipe 
           (gamestate-grid gs)
           (first (gamestate-in-pipes gs))
           (cell-index x (gamestate-tile-side-length gs))
           (cell-index y (gamestate-tile-side-length gs)))))
          (gamestate-time gs))]
                                                           
; (define-struct gamestate [grid in-pipes tile-side-length pipe-width gf replaced-pipes time])

; (define-struct grid [dim lot])
; (define-struct tile [pipe x y filled? completely-filled? direction]) 
; (define-struct goo-flow [path direction x y])
; (define-struct tile [pipe x y filled? completely-filled? direction])

;; cell-index : Number Number -> Number
;; Determines what row and the column is clicked on
(define (cell-index x tile-side-length)
  (+ 1 (floor (/ x tile-side-length))))

;; Task 10: Write a function that starts a game of Pipe Fantasy that simply uses the
;; helpers you write above. You cannot write check-expects, but you can play the game.

;; pipe-fantasy: GameState -> GameState
(define (pipe-fantasy initial-gamestate)
  (big-bang
      initial-gamestate ;; initial world state
    [to-draw draw-grid] ;; render the world state
    [on-mouse place-pipe-on-click]
    [on-tick countdown]  ;; start initial propagation after 5 seconds
    ;[stop-when end-gamestate?]
    )) ;; move from 2nd square and beyond 1 second 
 
 
; boundary-reached? : GooFlow Grid -> Boolean
; checks if boundary of the grid have been reached by the gooflow
(check-expect (boundary-reached? (make-goo-flow (cons (make-tile PIPE-T 0 1 #t #t UP) '()) UP 0 1) (make-grid 7 (cons (make-tile PIPE-T 0 1 #t #t UP) '()))) #t)
(check-expect (boundary-reached? (make-goo-flow (cons (make-tile PIPE-T 4 1 #t #t UP) '()) UP 4 1) (make-grid 7 (cons (make-tile PIPE-T 4 1 #t #t UP) '()))) #f) 
(check-expect (boundary-reached? (make-goo-flow (cons (make-tile PIPE-B 6 1 #t #t DOWN) '()) DOWN 6 1) (make-grid 7 (cons (make-tile PIPE-B 6 1 #t #t DOWN) '()))) #t)
(check-expect (boundary-reached? (make-goo-flow (cons (make-tile PIPE-B 0 1 #t #t DOWN) '()) DOWN 0 1) (make-grid 7 (cons (make-tile PIPE-B 0 1 #t #t DOWN) '()))) #f)
(check-expect (boundary-reached? (make-goo-flow (cons (make-tile PIPE-L 1 0 #t #t LEFT) '()) LEFT 1 0) (make-grid 7 (cons (make-tile PIPE-L 1 0 #t #t LEFT) '()))) #t)
(check-expect (boundary-reached? (make-goo-flow (cons (make-tile PIPE-L 2 1 #t #t LEFT) '()) LEFT 2 1) (make-grid 7 (cons (make-tile PIPE-L 2 1 #t #t LEFT) '()))) #f)
(check-expect (boundary-reached? (make-goo-flow (cons (make-tile PIPE-R 2 6 #t #t RIGHT) '()) RIGHT 2 6) (make-grid 7 (cons (make-tile PIPE-R 2 6 #t #t RIGHT) '()))) #t)
(check-expect (boundary-reached? (make-goo-flow (cons (make-tile PIPE-R 2 4 #t #t RIGHT) '()) RIGHT 2 4) (make-grid 7 (cons (make-tile PIPE-R 2 4 #t #t RIGHT) '()))) #f)

(define (boundary-reached? gf gr)
  (cond
    [(string=? (goo-flow-direction gf) UP) (= (tile-x (first (goo-flow-path gf))) 0)]
    [(string=? (goo-flow-direction gf) DOWN) (= (tile-x (first (goo-flow-path gf))) (- (grid-dim gr) 1))]
    [(string=? (goo-flow-direction gf) LEFT) (= (tile-y (first (goo-flow-path gf))) 0)]          
    [(string=? (goo-flow-direction gf) RIGHT) (= (tile-y (first (goo-flow-path gf))) (- (grid-dim gr) 1))]))
    

 
; empty-cell-reached? : Gooflow Grid -> Boolean
; checks if the gooflow has reached an empty cell
(check-expect (empty-cell-reached?
               (make-goo-flow (cons (make-tile PIPE-T 4 1 #t #t UP) '()) UP 4 1)  
               (make-grid 7 (cons (make-tile PIPE-TB 3 1 #f #f UP) (cons (make-tile PIPE-T 4 1 #t #t UP) '())))) #f)
(check-expect (empty-cell-reached?
               (make-goo-flow (cons (make-tile PIPE-T 0 1 #t #t UP) '()) UP 0 1)
               (make-grid 7 (cons (make-tile PIPE-TB 4 5 #f #f UP) (cons (make-tile PIPE-T 0 1 #t #t UP) '())))) #t)
(check-expect (empty-cell-reached? 
               (make-goo-flow (cons (make-tile PIPE-B 0 1 #t #t DOWN) '()) DOWN 0 1)
               (make-grid 7 (cons (make-tile PIPE-TL 1 1 #f #f DOWN) (cons (make-tile PIPE-B 0 1 #t #t DOWN) '())))) #f)
(check-expect (empty-cell-reached? 
               (make-goo-flow (cons (make-tile PIPE-B 6 1 #t #t DOWN) '()) DOWN 6 1)
               (make-grid 7 (cons (make-tile PIPE-TL 3 4 #f #f DOWN) (cons (make-tile PIPE-B 6 1 #t #t DOWN) '())))) #t)
(check-expect (empty-cell-reached? 
               (make-goo-flow (cons (make-tile PIPE-L 2 1 #t #t LEFT) '()) LEFT 2 1)
               (make-grid 7 (cons (make-tile PIPE-LR 2 0 #f #f LEFT) (cons (make-tile PIPE-L 2 1 #t #t LEFT) '())))) #f)
(check-expect (empty-cell-reached? 
               (make-goo-flow (cons (make-tile PIPE-L 2 0 #t #t LEFT) '()) LEFT 2 0)
               (make-grid 7 (cons (make-tile PIPE-LR 1 1 #f #f LEFT) (cons (make-tile PIPE-L 2 0 #t #t LEFT) '())))) #t)
(check-expect (empty-cell-reached?
               (make-goo-flow (cons (make-tile PIPE-R 2 4 #t #t RIGHT) '()) RIGHT 2 4) 
               (make-grid 7 (cons (make-tile PIPE-LR 2 5 #f #f RIGHT) (cons (make-tile PIPE-R 2 4 #t #t RIGHT) '())))) #f)
(check-expect (empty-cell-reached?
               (make-goo-flow (cons (make-tile PIPE-R 2 6 #t #t RIGHT) '()) RIGHT 2 6)
               (make-grid 7 (cons (make-tile PIPE-LR 1 3 #f #f RIGHT) (cons (make-tile PIPE-R 2 6 #t #t RIGHT) '())))) #t)
                
(define (empty-cell-reached? gf gr)
  (cond
    [(string=? (goo-flow-direction gf) UP) (boolean? (pipe-at gr (-  (tile-x (first (goo-flow-path gf))) 1) (tile-y (first (goo-flow-path gf)))))]
    [(string=? (goo-flow-direction gf) DOWN) (boolean? (pipe-at gr (+ (tile-x (first (goo-flow-path gf))) 1) (tile-y (first (goo-flow-path gf)))))]
    [(string=? (goo-flow-direction gf) LEFT) (boolean? (pipe-at gr (tile-x (first (goo-flow-path gf))) (- (tile-y (first (goo-flow-path gf))) 1)))]
    [(string=? (goo-flow-direction gf) RIGHT) (boolean? (pipe-at gr (tile-x (first (goo-flow-path gf))) (+ 1 (tile-y (first (goo-flow-path gf))))))]))
     
; pipe-has-opening? : GooFlow Grid -> Boolean
; checks if the most adjacent pipe has a respective opening
(check-expect (pipe-has-opening? (make-goo-flow (cons (make-tile PIPE-T 4 1 #t #t UP) '()) UP 4 1) 
                                 (make-grid 7 (cons (make-tile PIPE-TB 3 1 #f #f DOWN) (cons (make-tile PIPE-T 4 1 #t #t UP) '())))) #t)
(check-expect (pipe-has-opening? (make-goo-flow (cons (make-tile PIPE-T 4 1 #t #t UP) '()) UP 4 1)
                                 (make-grid 7 (cons (make-tile PIPE-TR 3 1 #f #f DOWN) (cons (make-tile PIPE-T 4 1 #t #t UP) '())))) #f)
(check-expect (pipe-has-opening?  
               (make-goo-flow (cons (make-tile PIPE-B 0 1 #t #t DOWN) '()) DOWN 0 1)
               (make-grid 7 (cons (make-tile PIPE-TL 1 1 #f #f UP) (cons (make-tile PIPE-B 0 1 #t #t DOWN) '())))) #t)
(check-expect (pipe-has-opening?  
               (make-goo-flow (cons (make-tile PIPE-B 0 1 #t #t DOWN) '()) DOWN 0 1)
               (make-grid 7 (cons (make-tile PIPE-BL 1 1 #f #f DOWN) (cons (make-tile PIPE-B 0 1 #t #t DOWN) '())))) #f)

(check-expect (pipe-has-opening?
               (make-goo-flow (cons (make-tile PIPE-L 2 1 #t #t LEFT) '()) LEFT 2 1)
               (make-grid 7 (cons (make-tile PIPE-LR 2 0 #f #f LEFT) (cons (make-tile PIPE-L 2 1 #t #t LEFT) '())))) #t)
(check-expect (pipe-has-opening?
               (make-goo-flow (cons (make-tile PIPE-L 2 1 #t #t LEFT) '()) LEFT 2 1) 
               (make-grid 7 (cons (make-tile PIPE-TL 2 0 #f #f LEFT) (cons (make-tile PIPE-L 2 1 #t #t LEFT) '())))) #f)
 
(check-expect (pipe-has-opening?
               (make-goo-flow (cons (make-tile PIPE-R 2 4 #t #t RIGHT) '()) RIGHT 2 4)
               (make-grid 7 (cons (make-tile PIPE-LR 2 5 #f #f RIGHT) (cons (make-tile PIPE-R 2 4 #t #t RIGHT) '())))) #t)
(check-expect (pipe-has-opening?
               (make-goo-flow (cons (make-tile PIPE-R 2 4 #t #t RIGHT) '()) RIGHT 2 4)
               (make-grid 7 (cons (make-tile PIPE-TR 2 5 #f #f RIGHT) (cons (make-tile PIPE-R 2 4 #t #t RIGHT) '())))) #f)

(define (pipe-has-opening? gf gr)
  (cond
    [(empty-cell-reached? gf gr) #f]
    [(string=? (goo-flow-direction gf) UP) (pipe-bot (pipe-at gr (- (tile-x (first (goo-flow-path gf))) 1) (tile-y (first (goo-flow-path gf)))))]
    [(string=? (goo-flow-direction gf) DOWN) (pipe-top (pipe-at gr (+ 1 (tile-x (first (goo-flow-path gf)))) (tile-y (first (goo-flow-path gf)))))]
    [(string=? (goo-flow-direction gf) LEFT) (pipe-right (pipe-at gr (tile-x (first (goo-flow-path gf))) (- (tile-y (first (goo-flow-path gf))) 1)))]
    [(string=? (goo-flow-direction gf) RIGHT) (pipe-left (pipe-at gr (tile-x (first (goo-flow-path gf))) (+ 1 (tile-y (first (goo-flow-path gf))))))]))



; end-gamestate? : Gamestate -> Boolean
#;(define (end-gamestate? gs)
  (or (boundary-reached? (gamestate-gf gs) (gamestate-grid gs))
      (empty-cell-reached? (gamestate-gf gs) (gamestate-grid gs))
      (not (pipe-has-opening? (gamestate-gf gs) (gamestate-grid gs)))))






























    
;; Task 4 --


;; Gooflow
(define (grid-goo-propagate gf grid)
  (cond
    [(string=? UP (goo-flow-direction gf)) (if (and (pipe? (pipe-at grid (goo-flow-x gf) (- (goo-flow-y gf) 1)))
                                                  (pipe-bot (pipe-at grid (goo-flow-x gf) (- (goo-flow-y gf) 1))))
                                                 (cond
                                                   [(pipe-top (pipe-at grid (goo-flow-x gf) (- (goo-flow-y gf) 1)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (goo-flow-x gf) (- (goo-flow-y gf) 1))
                                                                                    (goo-flow-x gf) (- (goo-flow-y gf) 1) #t #f "up") (goo-flow-path gf))
                                                                    UP (goo-flow-x gf) (- (goo-flow-y gf) 1))]
                                                   [(pipe-left (pipe-at grid (goo-flow-x gf) (- (goo-flow-y gf) 1)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (goo-flow-x gf) (- (goo-flow-y gf) 1))
                                                                                    (goo-flow-x gf) (- (goo-flow-y gf) 1) #t #f "left") (goo-flow-path gf))
                                                                    LEFT (goo-flow-x gf) (- (goo-flow-y gf) 1))]
                                                   [(pipe-right (pipe-at grid (goo-flow-x gf) (- (goo-flow-y gf) 1)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (goo-flow-x gf) (- (goo-flow-y gf) 1))
                                                                                    (goo-flow-x gf) (- (goo-flow-y gf) 1) #t #f "right") (goo-flow-path gf))
                                                                    RIGHT (goo-flow-x gf) (- (goo-flow-y gf) 1))])
                                                 (make-goo-flow (goo-flow-path gf) ((goo-flow-direction gf) (goo-flow-x gf) (goo-flow-y gf))))]
    [(string=? LEFT  (goo-flow-direction gf))  (if (and (pipe? (pipe-at grid (- (goo-flow-x gf) 1) (goo-flow-y gf)))
                                                  (pipe-right (pipe-at grid (- (goo-flow-x gf) 1) (goo-flow-y gf))))
                                                 (cond
                                                   [(pipe-left (pipe-at grid (- (goo-flow-x gf) 1) (goo-flow-y gf)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (- (goo-flow-x gf) 1) (goo-flow-y gf))
                                                                                    (- (goo-flow-x gf) 1) (goo-flow-y gf) #t #f "left") (goo-flow-path gf))
                                                                    LEFT (- (goo-flow-x gf) 1) (goo-flow-y gf))]
                                                   [(pipe-top (pipe-at grid (- (goo-flow-x gf) 1) (goo-flow-y gf)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (- (goo-flow-x gf) 1) (goo-flow-y gf))
                                                                                    (- (goo-flow-x gf) 1) (goo-flow-y gf) #t #f "up") (goo-flow-path gf))
                                                                    UP (- (goo-flow-x gf) 1) (goo-flow-y gf))]
                                                   [(pipe-bot (pipe-at grid (- (goo-flow-x gf) 1) (goo-flow-y gf)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (- (goo-flow-x gf) 1) (goo-flow-y gf))
                                                                                    (- (goo-flow-x gf) 1) (goo-flow-y gf) #t #f "down") (goo-flow-path gf))
                                                                    DOWN (- (goo-flow-x gf) 1) (goo-flow-y gf))])
                                                 (make-goo-flow (goo-flow-path gf) (goo-flow-direction gf) (goo-flow-x gf) (goo-flow-y gf)))]
    [(string=? RIGHT (goo-flow-direction gf)) (if (and (pipe? (pipe-at grid (+ (goo-flow-x gf) 1) (goo-flow-y gf)))
                                                  (pipe-left (pipe-at grid (+ (goo-flow-x gf) 1) (goo-flow-y gf))))
                                                 (cond
                                                   [(pipe-right (pipe-at grid (+ (goo-flow-x gf) 1) (goo-flow-y gf)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (+ 1 (goo-flow-x gf)) (goo-flow-y gf))
                                                                                    (+ 1 (goo-flow-x gf)) (goo-flow-y gf) #t #f "right") (goo-flow-path gf))
                                                                    RIGHT (+ (goo-flow-x gf) 1) (goo-flow-y gf))]
                                                   [(pipe-top (pipe-at grid (+ (goo-flow-x gf) 1) (goo-flow-y gf)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (+ 1 (goo-flow-x gf)) (goo-flow-y gf))
                                                                                    (+ 1 (goo-flow-x gf)) (goo-flow-y gf) #t #f "up") (goo-flow-path gf))
                                                                    UP (+ (goo-flow-x gf) 1) (goo-flow-y gf))]
                                                   [(pipe-bot (pipe-at grid (+ (goo-flow-x gf) 1) (goo-flow-y gf)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (+ 1 (goo-flow-x gf)) (goo-flow-y gf))
                                                                                    (+ 1 (goo-flow-x gf)) (goo-flow-y gf) #t #f "down") (goo-flow-path gf))
                                                                    DOWN (+ (goo-flow-x gf) 1) (goo-flow-y gf))])
                                                 (make-goo-flow (goo-flow-path gf) (goo-flow-direction gf) (goo-flow-x gf) (goo-flow-y gf)))]
    [(string=? DOWN (goo-flow-direction gf)) (if (and (pipe? (pipe-at grid (goo-flow-x gf) (+ (goo-flow-y gf) 1)))
                                                  (pipe-top (pipe-at grid (goo-flow-x gf) (+ (goo-flow-y gf) 1))))
                                                 (cond
                                                   [(pipe-bot (pipe-at grid (goo-flow-x gf) (+ (goo-flow-y gf) 1)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (goo-flow-x gf) (+ 1 (goo-flow-y gf)))
                                                                                    (goo-flow-x gf) (+ 1 (goo-flow-y gf)) #t #f "down") (goo-flow-path gf))
                                                                    DOWN (goo-flow-x gf) (+ (goo-flow-y gf) 1))]
                                                   [(pipe-left (pipe-at grid (goo-flow-x gf) (+ (goo-flow-y gf) 1)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (goo-flow-x gf) (+ 1 (goo-flow-y gf)))
                                                                                    (goo-flow-x gf) (+ 1 (goo-flow-y gf)) #t #f "left") (goo-flow-path gf))
                                                                    LEFT (goo-flow-x gf) (+ (goo-flow-y gf) 1))]
                                                   [(pipe-right (pipe-at grid (goo-flow-x gf) (+ (goo-flow-y gf) 1)))
                                                    (make-goo-flow (cons (make-tile (pipe-at grid (goo-flow-x gf) (+ 1 (goo-flow-y gf)))
                                                                                    (goo-flow-x gf) (+ 1 (goo-flow-y gf)) #t #f "right") (goo-flow-path gf))
                                                                    RIGHT (goo-flow-x gf) (+ (goo-flow-y gf) 1))])
                                                 (make-goo-flow (goo-flow-path gf) (goo-flow-direction gf) (goo-flow-x gf) (goo-flow-y gf)))]))




; pipe-direction : GooFlow Grid -> Direction
; returns the next direction of goo flow with respect to the grid
(define (pipe-direction gf gr)
  (cond
    [(string=? (goo-flow-direction gf) UP)
     (cond
       [(pipe-top (pipe-at gr (- (tile-x (first (goo-flow-path gf))) 1) (tile-y (first (goo-flow-path gf))))) UP]
       [(pipe-right (pipe-at gr (- (tile-x (first (goo-flow-path gf))) 1) (tile-y (first (goo-flow-path gf))))) RIGHT]
       [(pipe-left (pipe-at gr (- (tile-x (first (goo-flow-path gf))) 1) (tile-y (first (goo-flow-path gf))))) LEFT])]
    [(string=? (goo-flow-direction gf) DOWN)
     (cond
       [(pipe-bot (pipe-at gr (+ 1 (tile-x (first (goo-flow-path gf)))) (tile-y (first (goo-flow-path gf))))) DOWN]
       [(pipe-right (pipe-at gr (+ 1 (tile-x (first (goo-flow-path gf)))) (tile-y (first (goo-flow-path gf))))) RIGHT]
       [(pipe-left (pipe-at gr (+ 1 (tile-x (first (goo-flow-path gf)))) (tile-y (first (goo-flow-path gf))))) LEFT])]
    [(string=? (goo-flow-direction gf) LEFT)
     (cond
       [(pipe-left (pipe-at gr (tile-x (first (goo-flow-path gf))) (- (tile-y (first (goo-flow-path gf))) 1))) LEFT]
       [(pipe-top (pipe-at gr (tile-x (first (goo-flow-path gf))) (- (tile-y (first (goo-flow-path gf))) 1))) UP]
       [(pipe-bot (pipe-at gr (tile-x (first (goo-flow-path gf))) (- (tile-y (first (goo-flow-path gf))) 1))) DOWN])]
    [(string=? (goo-flow-direction gf) RIGHT)
     (cond
       [(pipe-right (pipe-at gr (tile-x (first (goo-flow-path gf))) (+ 1 (tile-y (first (goo-flow-path gf)))))) RIGHT]
       [(pipe-bot (pipe-at gr (tile-x (first (goo-flow-path gf))) (+ 1 (tile-y (first (goo-flow-path gf)))))) DOWN]
       [(pipe-top (pipe-at gr (tile-x (first (goo-flow-path gf))) (+ 1 (tile-y (first (goo-flow-path gf)))))) UP])]))

 

 
; (define-struct grid [dim lot])
; (define-struct tile [pipe x y filled? completely-filled? direction]) 

;; returns a list of the pipes that have been replaced
;; pipes-replaced : Grid -> [List-of Tile]

(check-expect (pipes-replaced (make-grid 7 (list (make-tile PIPE-R 2 2 #t #t RIGHT) ))) empty)

(check-expect (pipes-replaced (make-grid 7 (list (make-tile PIPE-R 2 2 #t #t RIGHT)
                                                 (make-tile PIPE-LR 2 3 #f #f RIGHT)
                                                 (make-tile PIPE-TL 2 3 #f #f UP)))) (list (make-tile PIPE-LR 2 3 #f #f RIGHT)))
(check-expect (pipes-replaced (make-grid 7 (list (make-tile PIPE-T 2 2 #t #t RIGHT)
                                                 (make-tile PIPE-TB 3 2 #f #f RIGHT)
                                                 (make-tile PIPE-TR 4 4 #f #f UP)))) empty)

(define (pipes-replaced grid)
         (cond
           [(> 2 (length (grid-lot grid))) '()]
           [(<= 2 (length (grid-lot grid)))
            (if (tile-equal? (first (grid-lot grid)) (tile-x (first (rest (grid-lot grid))))
                             (tile-y (first (rest (grid-lot grid)))))
                (cons (first (grid-lot grid)) (pipes-replaced (make-grid (grid-dim grid) (rest (grid-lot grid)))))
                (pipes-replaced (make-grid (grid-dim grid) (rest (grid-lot grid)))))]))

;; gamestate-init : Number Number Number Direction [ListOf Pipes] -> GameState
;; creates a game state given the information, dimension, x-coordinate (row), y-coordinate (column),
;; direction and list of pipes

(check-expect (gamestate-init 7 2 1 "down" PIPE-LIST 10)
              (make-gamestate
               (make-grid 7 (list (make-tile (make-pipe #false #true #false #false #true) 2 1 #true #false "down")))
               (list
                (make-pipe #true #false #true #false #false)
                (make-pipe #true #false #false #true #false)
                (make-pipe #false #true #true #false #false)
                (make-pipe #false #true #false #true #false)
                (make-pipe #true #true #false #false #false)
                (make-pipe #false #false #true #true #false)
                (make-pipe #true #true #true #true #false)
                (make-pipe #true #false #true #false #false)
                (make-pipe #true #false #false #true #false)
                (make-pipe #false #true #true #false #false)
                (make-pipe #false #true #false #true #false))
               100
               60
               (make-goo-flow (list (make-tile (make-pipe #false #true #false #false #true) 2 1 #true #false "down")) "down" 2 1)
               0
               10))

(check-expect (gamestate-init 8 6 6 "up" PIPE-LIST 2)
              (make-gamestate
               (make-grid 8 (list (make-tile (make-pipe #true #false #false #false #true) 6 6 #true #false "up")))
               (list
                (make-pipe #true #false #true #false #false)
                (make-pipe #true #false #false #true #false)
                (make-pipe #false #true #true #false #false)
                (make-pipe #false #true #false #true #false)
                (make-pipe #true #true #false #false #false)
                (make-pipe #false #false #true #true #false)
                (make-pipe #true #true #true #true #false)
                (make-pipe #true #false #true #false #false)
                (make-pipe #true #false #false #true #false)
                (make-pipe #false #true #true #false #false)
                (make-pipe #false #true #false #true #false))
               100
               60
               (make-goo-flow (list (make-tile (make-pipe #true #false #false #false #true) 6 6 #true #false "up")) "up" 6 6)
               0
               2))
              
(check-expect (gamestate-init 4 0 0 "left" PIPE-LIST 0)
              (make-gamestate
               (make-grid 4 (list (make-tile (make-pipe #false #false #true #false #true) 0 0 #true #false "left")))
               (list
                (make-pipe #true #false #true #false #false)
                (make-pipe #true #false #false #true #false)
                (make-pipe #false #true #true #false #false)
                (make-pipe #false #true #false #true #false)
                (make-pipe #true #true #false #false #false)
                (make-pipe #false #false #true #true #false)
                (make-pipe #true #true #true #true #false)
                (make-pipe #true #false #true #false #false)
                (make-pipe #true #false #false #true #false)
                (make-pipe #false #true #true #false #false)
                (make-pipe #false #true #false #true #false))
               100
               60
               (make-goo-flow (list (make-tile (make-pipe #false #false #true #false #true) 0 0 #true #false "left")) "left" 0 0)
               0
               0))
              
(check-expect (gamestate-init 7 3 3 "right" PIPE-LIST 30)
              (make-gamestate
               (make-grid 7 (list (make-tile (make-pipe #false #false #false #true #true) 3 3 #true #false "right")))
               (list
                (make-pipe #true #false #true #false #false)
                (make-pipe #true #false #false #true #false)
                (make-pipe #false #true #true #false #false)
                (make-pipe #false #true #false #true #false)
                (make-pipe #true #true #false #false #false)
                (make-pipe #false #false #true #true #false)
                (make-pipe #true #true #true #true #false)
                (make-pipe #true #false #true #false #false)
                (make-pipe #true #false #false #true #false)
                (make-pipe #false #true #true #false #false)
                (make-pipe #false #true #false #true #false))
               100
               60
               (make-goo-flow (list (make-tile (make-pipe #false #false #false #true #true) 3 3 #true #false "right")) "right" 3 3)
               0
               30))

(define (gamestate-init dim x y direction lop ticks-left)
  (make-gamestate (make-grid dim (list (make-tile (what-pipe direction) x y #t #f direction))) lop 100 60
                  (make-goo-flow (list (make-tile (what-pipe direction) x y #t #f direction)) direction x y)
                  (length (pipes-replaced (make-grid dim (list (make-tile (what-pipe direction) x y #t #f direction))))) ticks-left))


;; Task 2: Write a function get-score: GameState -> Integer that computes the current score of the game.

 
;; get-score: GameState -> Integer
;; produces current score of the game being played 

(check-expect (get-score (make-gamestate (make-grid 7  (list (make-tile PIPE-R 2 2 #t #t RIGHT)
                                                 (make-tile PIPE-LR 2 3 #f #f RIGHT)))
                                         ALL-PIPES 100 60 (make-goo-flow (list (make-tile PIPE-R 2 2 #t #t RIGHT)) RIGHT 2 2)
                                         0 140)) 50)

(check-expect (get-score (make-gamestate (make-grid 7  (list (make-tile PIPE-R 2 2 #t #t RIGHT)
                                                             (make-tile PIPE-LR 2 3 #f #f RIGHT)
                                                             (make-tile PIPE-LR 2 6 #f #f RIGHT)))
                                         ALL-PIPES 100 60 (make-goo-flow (list (make-tile PIPE-R 2 2 #t #t RIGHT)
                                                                               (make-tile PIPE-LR 2 3 #f #f RIGHT)) RIGHT 2 3)
                                         0 140)) 150)
(check-expect (get-score (make-gamestate (make-grid 7  (list (make-tile PIPE-R 2 2 #t #t RIGHT)
                                                             (make-tile PIPE-LR 2 3 #t #t RIGHT)
                                                             (make-tile PIPE-TL 2 4 #f #f UP)
                                                             (make-tile PIPE-TBLR 2 4 #t #t RIGHT)))
                                         ALL-PIPES 100 60 (make-goo-flow (list (make-tile PIPE-R 2 2 #t #t RIGHT)
                                                             (make-tile PIPE-LR 2 3 #t #t RIGHT)
                                                             (make-tile PIPE-TBLR 2 4 #t #t RIGHT)) RIGHT 2 4)
                                         1 28)) 250)
(define (get-score gs)
  (- (* 50 (- (length (goo-flow-path (gamestate-gf gs))) (- (length ALL-PIPES) (+ (length (gamestate-in-pipes gs)) (length (grid-lot (gamestate-grid gs))))))) 100))



; (define-struct goo-flow [path direction x y])                                                           
; (define-struct gamestate [grid in-pipes tile-side-length pipe-width gf replaced-pipes time])
; (define-struct grid [dim lot])
; (define-struct tile [pipe x y filled? completely-filled? direction])  

;; what-pipe : Direction -> Pipe
;; creates a starting pipe with given direction
(check-expect (what-pipe "up") (make-pipe #t #f #f #f #t))
(check-expect (what-pipe "down") (make-pipe #f #t #f #f #t))
(check-expect (what-pipe "left") (make-pipe #f #f #t #f #t))
(check-expect (what-pipe "right") (make-pipe #f #f #f #t #t))
(define (what-pipe direction)
  (cond  
    [(string=? direction UP) (make-pipe #t #f #f #f #t)]
    [(string=? direction DOWN) (make-pipe #f #t #f #f #t)]
    [(string=? direction LEFT) (make-pipe #f #f #t #f #t)]
    [(string=? direction RIGHT) (make-pipe #f #f #f #t #t)]))
    
;; TASK 7 

(define PIPE-FANTASY-0 (gamestate-init 7 2 3 "right" ALL-PIPES 140)) 
(define PIPE-FANTASY-1 (gamestate-init 9 1 4 "down" ALL-PIPES 140)) 


; (define (gamestate-init dim x y direction lop ticks-left)



