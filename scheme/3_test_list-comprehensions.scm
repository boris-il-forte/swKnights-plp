#lang racket

(require "2_list-comprehensions.scm")

; Tests and examples

(list-of x
         (x in '(1 2)))

(list-of x
         (x range 1 10 2))

(list-of (list x y)
         (x in '(1 2))
         (y range 1 10 2))

(list-of (list x y)
         (x in '(a b c))
         (y in '(1 2)))

(list-of (list x y)
         (x in (range 3))
         (y in (range 3))
         (= x y))

(list-of (list x y)
         (x range 0 3)
         (y range 0 3 1)
         (not (= x y)))

(list-of (+ y 6)
         (x in '(1 2 3 4 5))
         (odd? x)
         (y is (* x x)))

(list-of (+ y 6)
         (x range 1 6)
         (odd? x)
         (y is (* x x)))

(list-of (+ y 6)
         (x range 1 6 2)
         (y is (* x x)))