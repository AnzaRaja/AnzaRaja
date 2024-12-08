;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |AnzaCS2500 hw6|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)



;; Part 1

;; Task 1: complete the data design

(define-struct pipe [top bot left right])
;; A Pipe is a (make-pipe Boolean Boolean Boolean Boolean)
;; Interpretation: a pipe with openings in the given directions. A  #true for 
;; one of top, bot, left, right indicates an opening in that direction.
;; Examples:
(define PIPE-TL (make-pipe #true #false #true #false))
(define PIPE-TR (make-pipe #true #false #false #true))
(define PIPE-BL (make-pipe #false #true #true #false))
(define PIPE-BR (make-pipe #false #true #false #true))
(define PIPE-TB (make-pipe #true #true #false #false))
(define PIPE-LR (make-pipe #false #false #true #true))
(define PIPE-TBLR (make-pipe #true #true #true #true))
;; Template :
;; pipe-templ : Pipe -> ?
(define (pipe-templ p)
  (... (pipe-top p) ...
       (pipe-bot p) ...
       (pipe-left p) ...
       (pipe-right p) ...))

;; Task 2: Create a list called ALL-PIPES that contains every kind of pipe.

;; A [List-of AllPipes] is one of
;; - empty
;; - (cons list-of-all-pipes [List-of AllPipes])
;; Interpretation: Represents a list of all the pipes.
;; - empty represents a list with no pipes
;; - (cons first rest) represents a list with a _first_ pipe and the _rest_
;; of the pipes
;; Examples
(define ALL-PIPES (cons PIPE-TL
                        (cons PIPE-TR
                              (cons PIPE-BL
                                    (cons PIPE-BR
                                          (cons PIPE-TB
                                                (cons PIPE-LR
                                                      (cons PIPE-TBLR empty))))))))

;; Task 3: During the game, the player places pipes onto square tiles on the board.
;; Design a function with the following signature and purpose statement:

;; pipe->image: Pipe Integer Integer -> Image
;; Draws the given pipe on a square tile with length tile-side-length. The width
;; of the pipe is pipe-width. Pipe-width should be less than tile-side-length
(define (pipe->image pipe tile-side-length pipe-width)
  (cond
    [(and (pipe-top pipe) (pipe-left pipe)) (TL pipe tile-side-length pipe-width)]
    [(and (pipe-top pipe) (pipe-right pipe)) (TR pipe tile-side-length pipe-width)]
    [(and (pipe-bot pipe) (pipe-left pipe)) (BL pipe tile-side-length pipe-width)]
    [(and (pipe-bot pipe) (pipe-right pipe)) (BR pipe tile-side-length pipe-width)]
    [(and (pipe-top pipe) (pipe-bot pipe)) (TB pipe tile-side-length pipe-width)]
    [(and (pipe-left pipe) (pipe-right pipe)) (LR pipe tile-side-length pipe-width)]
    [(and (pipe-top pipe) (pipe-bot pipe) (pipe-left pipe) (pipe-right pipe)) (TBLR pipe tile-side-length pipe-width)]
    [else (EMPTY-TILE pipe tile-side-length)]))

;; TB : Pipe-TB Number Number -> Image
;; Takes a pipe with a top and bottom opening and produces an image.
(define (TB pipe tile-side-length pipe-width)
  (place-image (rectangle pipe-width tile-side-length "solid" "black") (/ tile-side-length 2) (/ tile-side-length 2)
               (square tile-side-length "solid" "gray")))

;; LR: Pipe-LR Number Number -> Image
;; Takes a pipe with a left and right opening and produces an image.
(define (LR pipe tile-side-length pipe-width)
  (place-image (rectangle tile-side-length pipe-width "solid" "black") (/ tile-side-length 2) (/ tile-side-length 2)
               (square tile-side-length "solid" "gray")))

;; TL: Pipe-TL Number Number -> Image
;; Takes a pipe with a top and left opening and produces an image.
(define (TL pipe tile-side-length pipe-width)
  (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "black") (/ tile-side-length 2) (/ tile-side-length 4) 
               (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width "solid" "black") (/ tile-side-length 4) (/ tile-side-length 2)
                            (square tile-side-length "solid" "gray"))))

;; TR: Pipe-TR Number Number -> Image
;; Takes a pipe with a top and right opening and produces an image.
(define (TR pipe tile-side-length pipe-width)
  (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "black") (/ tile-side-length 2) (/ tile-side-length 4) 
               (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width  "solid" "black") (* tile-side-length 0.75) (/ tile-side-length 2)
                            (square tile-side-length "solid" "gray"))))

;; BL: Pipe-BL Number Number -> Image
;; Takes a pipe with a bottom and left opening and produces an image.
(define (BL pipe tile-side-length pipe-width)
  (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "black") (/ tile-side-length 2) (* tile-side-length 0.75) 
               (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width "solid" "black") (/ tile-side-length 4) (/ tile-side-length 2)
                            (square tile-side-length "solid" "gray"))))

;; BR: Pipe-BR Number Number -> Image
;; Takes a pipe with a botton and right opening and produces an image.
(define (BR pipe tile-side-length pipe-width)
  (place-image (rectangle pipe-width (/ tile-side-length 2) "solid" "black") (/ tile-side-length 2) (* tile-side-length 0.75) 
               (place-image (rectangle (+ pipe-width (/ tile-side-length 2)) pipe-width  "solid" "black") (* tile-side-length 0.75) (/ tile-side-length 2)
                            (square tile-side-length "solid" "gray"))))

;; TBLR: Pipe-TBLR Number Number -> Image
;; Takes a pipe with a top, boottom, left and right opening and produces an image.
(define (TBLR pipe tile-side-length pipe-width)
  (place-image (rectangle pipe-width tile-side-length "solid" "black") (/ tile-side-length 2) (/ tile-side-length 2)
               (place-image (rectangle tile-side-length pipe-width "solid" "black") (/ tile-side-length 2) (/ tile-side-length 2)
                            (square tile-side-length "solid" "gray"))))

;; EMPTY-TILE : Pipe Number Number Number -> Image
;; Takes a pipe with all openings #false and produces and empty tile.
(define (EMPTY-TILE pipe tile-side-length)
  (square tile-side-length "outline" "black"))

;; Part 2

;; Task 4: Complete a data design called Grid that represents a grid.
;; You should construct several examples of varying sizes and with different pipes places on them.

;; Recommendation 2: A better approach is to only represent the list of placed pipes.
;; So, a blank grid would be represented by the empty list. Thus each item in the list must represent both a pipe
;; and its coordinates on the grid. (This requires an auxiliary data definition for a pipe with its coordinates.)


;COMPLETE DESIGN RECIPE FOR STRUCTS

(define-struct tile [pipe x y])
;; A tile is a (make-tile Pipe Number Number)
;; Interpretation : Represents a single tile with a specific pipe and its
;; position represented by x and y coordinates.
;; Examples:
(define TILE-1 (make-tile PIPE-TB 3 2))
(define TILE-2 (make-tile PIPE-BR 6 1))
(define TILE-3 (make-tile PIPE-LR 2 5))
;; Template :
;; tile-templ : Tile -> ?
(define (tile-templ t)
  (... (tile-pipe t) ...
       (tile-x t) ...
       (tile-y t) ...))

(define-struct grid [dim lot])
;; A grid is a (make-grid Number [List-of Tile])
;; Interpretation : A grid with a number representing its dimensions and
;; a [List-of Tile] representing a single tile with its openinings and
;; x and y coordinates.


;; grid : Number [List-of Tile] -> Grid
;; Represents a grid with given dimension and a [List-of Tile]
;; Examples:
(define GRID-0 (make-grid 10 '()))
(define GRID-1 (make-grid 14 (list (make-tile PIPE-TL 10 2) (make-tile PIPE-TB 6 5))))
(define GRID-2 (make-grid 15 (list (make-tile PIPE-TBLR 6 12))))
(define GRID-3 (make-grid 15 (list (make-tile PIPE-TBLR 3 10))))
(define GRID-4 (make-grid 90 (list (make-tile PIPE-TBLR 50 50))))
(define GRID-5 (make-grid 45 (list (make-tile PIPE-TBLR 34 43))))
(define GRID-6 (make-grid 32 (list (make-tile PIPE-TBLR 7 4))))
(define GRID-7 (make-grid 61 (list (make-tile PIPE-TBLR 6 60))))
;; Template :
;; grid-templ : Grid -> ?
(define (grid-templ g)
  (... (grid-dim g) ...
       (lot-templ (grid-lot g))))



;; Task 5: Create an example that represents an empty 7 × 7 grid called STARTING-GRID.
(define STARTING-GRID (make-grid 7 '()))


;; Task 6: Complete the following function designs (do not modify the signatures):

;; place-pipe: Grid Pipe Integer Integer -> Grid
;; Places the pipe on the grid at the given row and column. We assume that the
;; row and column are valid positions on the grid.
(check-expect (place-pipe GRID-1 PIPE-TB 4 5)
              (make-grid 14
                         (list
                          (make-tile (make-pipe #true #true #false #false) 4 5)
                          (make-tile (make-pipe #true #false #true #false) 10 2)
                          (make-tile (make-pipe #true #true #false #false) 6 5))))

(check-expect (place-pipe GRID-0 PIPE-TL 8 1)
              (make-grid 10
                         (list
                          (make-tile (make-pipe #true #false #true #false) 8 1))))

(check-expect (place-pipe GRID-5 PIPE-TBLR 40 32)
              (make-grid 45
                         (list
                          (make-tile (make-pipe #true #true #true #true) 40 32)
                          (make-tile (make-pipe #true #true #true #true) 34 43))))

(define (place-pipe grid pipe row col)
  (make-grid (grid-dim grid)
             (cons (make-tile pipe row col) (grid-lot grid ))))
  
;; pipe-at: Grid Integer Integer -> [Optional Pipe]
;; Produces the pipe at the given row and column, or #false if that position is
;; is blank. We assume that the row and column are valid positions on the grid.
(check-expect (pipe-at GRID-3 6 2) #false)
(check-expect (pipe-at GRID-5 34 43) (make-tile (make-pipe #true #true #true #true) 34 43))
(check-expect (pipe-at GRID-1 6 5) (make-tile (make-pipe #true #true #false #false) 6 5))
(check-expect (pipe-at GRID-3 4 1) #false)
(check-expect (pipe-at GRID-7 6 60) (make-tile (make-pipe #true #true #true #true) 6 60))

(define (pipe-at grid row col)
  (cond
    [(empty? (grid-lot grid)) #false]
    [(cons? (grid-lot grid)) (if (tile-equal? (first (grid-lot grid)) row col) (first (grid-lot grid))
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

(define (grid->image grid tile-side-length pipe-width)
  (place-pipes (grid-lot grid) tile-side-length (blank-grid (grid-dim grid) (grid-dim grid) tile-side-length) pipe-width))
                              ;(grid->image (make-grid (grid-dim grid) (rest (grid-lot grid))) tile-side-length pipe-width)]))

;; place-pipes : [List-of Tile] Number Image Number -> Image
;; Produces and image of the rest of the pipes on top of the current image.

(define (place-pipes list-of-tiles tile-side-length image pipe-width)
  (cond
    [(empty? list-of-tiles) image]
    [(cons? list-of-tiles) (place-pipes (rest list-of-tiles) tile-side-length
                                        (place-image
                                         (pipe->image (tile-pipe (first list-of-tiles)) tile-side-length pipe-width)
                                         (- (* tile-side-length (tile-x (first list-of-tiles))) (/ tile-side-length 2))
                                         (- (* tile-side-length (tile-y (first list-of-tiles))) (/ tile-side-length 2))
                                         image) pipe-width)]))


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

       

;; Part 3: Game Interactions

;; Task 8: Complete a data design called GameState.
;; For now, a game should have a grid and a list of “incoming pipes”
;; that may appear when the player clicks on a grid cell. In a complete game,
;; the pipes are generated randomly and there is an infinite supply of pipes.
;; However, for now, you’ll have a fixed list of incoming pipes.

(define-struct gamestate [grid in-pipes tile-side-length pipe-width])
;; A GameState is a (make-game-state Grid [List-of Pipes] Number Number)
;; Interpretation: A GameState represents the state of the game where:
;; - grid - is what the grid currently looks like
;; - in-pipes - is the list of incoming pipes
;; Examples:
(define GAME-STATE-1 (make-gamestate
                      GRID-1
                      (cons PIPE-BR (cons PIPE-LR (cons PIPE-TB empty))) 30 15))
(define GAME-STATE-2 (make-gamestate
                      GRID-2
                      (cons PIPE-TL (cons PIPE-TBLR empty)) 25 15))
(define GAME-STATE-3 (make-gamestate
                      GRID-3
                      (cons PIPE-TR empty) 40 20))
(define GAME-STATE-4 (make-gamestate
                      GRID-1
                      empty 30 15))
;; Template:
;; gs-templ : GameState -> ?
(define (gs-templ gs)
  (... (grid-templ (game-state-grid gs)) ...
       (lop-templ (game-state-in-pipes gs)) ...
       (game-state-tile-side-length gs) ...
       (game-state-pipe-width gs) ...))

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



;; draw-grid : GameState -> Image
;; Draws the current game board
(define (draw-grid gs)
  (grid->image (gamestate-grid gs)
                (gamestate-tile-side-length gs)
                (gamestate-pipe-width gs)))

#;(define (draw-grid gs)
  (... (grid->image (game-state-grid gs)) ...
       (lop-templ (game-state-in-pipes gs)) ...
       (game-state-tile-side-length gs) ...
       (game-state-pipe-width gs) ...))

;; Task 9: Complete the following function design:
;; place-pipe-on-click : GameState Integer Integer MouseEvent -> GameState`
;; If the user clicks on a tile and there are incoming pipes available, places
;; the next incoming pipe on that tile. If no pipes are available, does nothing.

(define (place-pipe-on-click gs x y me)
  (if (string=? me "button-down")
      (cond
        [(empty? (gamestate-in-pipes gs)) gs]
        [(cons? (gamestate-in-pipes gs))
         (make-gamestate
          (place-pipe
          (gamestate-grid gs)
          (first (gamestate-in-pipes gs))
          (cell-index x (gamestate-tile-side-length gs))
          (cell-index y (gamestate-tile-side-length gs)))
          (rest (gamestate-in-pipes gs))
          (gamestate-tile-side-length gs)
          (gamestate-pipe-width gs))])
      gs))

;; cell-index : Number Number -> Number
;; Determines what row and the column is clicked on
(define (cell-index x tile-side-length)
  (+ 1 (floor (/ x tile-side-length))))

;; Task 10: Write a function that starts a game of Pipe Fantasy that simply uses the
;; helpers you write above. You cannot write check-expects, but you can play the game.

;; pipe-fantasy: GameState -> GameState
(define (pipe-fantasy initial-game-state)
  (big-bang
      initial-game-state ;; initial world state
    [to-draw draw-grid] ;; render the world state
    [on-mouse place-pipe-on-click]))


;    [stop-when game-over?]))   ;; change world state from one moment to the other))
