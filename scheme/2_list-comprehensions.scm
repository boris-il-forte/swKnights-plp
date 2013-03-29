#lang racket

; Simple (non optimized at all) list comprehension macro for Scheme

; Example:
; (list-of (+ y 6)
;         (x range 1 6)
;         (odd? x)
;         (y is (* x x)))   ==>   '(7 15 31)
;
; Syntax and "suggestions" for the implementation stolen from:
; * http://wiki.call-cc.org/eggref/4/list-of
; * http://www.phyast.pitt.edu/~micheles/scheme/scheme17.html
; With respect to the latter link, this macro does NOT support
; comprehensions plus destructuring like:
; (list-of (+ x y) ((x y) in '((1 2)(3 4)))) => '(3 7)

(define-syntax list-of
  (syntax-rules ()
    ((_ expr clause ...)
     (reverse (internal-list-of '() expr clause ...))))) ; that reverse here is quite ugly :)

(define-syntax internal-list-of
  (syntax-rules (in is range)
    ; Loop over the elements of list-expr, in order from the start of the list, 
    ; binding each element of the list in turn to var.
    ((_ acc exp (var in list-expr) rest ...)
     (let loop ((a acc) (l list-expr))
       (if (null? l)
           a
           (loop
            (let ((var (car l)))
              (internal-list-of a exp rest ...)
              ) (cdr l)))))
    ; (var range first past [step])
    ; Loop over the implicit list of numbers that contains beg as its first element 
    ; and increments each succeeding element by step. The list ends before end, 
    ; which is not an element of the list. If step is not given it defaults to 1, 
    ; if first is less than past and -1 otherwise.
    ((_ acc exp (var range beg end step) rest ...)
     (let loop ((a acc) (i beg))
       (if (>= i end)
           a
           (loop
            ((lambda (var) (internal-list-of a exp rest ...)) i) (+ step i)))))
    ((_ acc exp (var range beg end) rest ...)
     (let ((x (if (< beg end) 1 -1)))
       (let loop ((a acc) (i beg))
         (if (>= i end)
             a
             (loop
              ((lambda (var) (internal-list-of a exp rest ...)) i) (+ x i))))))
    ; Bind var to the value obtained by evaluating expr.
    ((_ acc exp (var is expr) rest ...)
     (let ((var expr))
       (internal-list-of acc exp rest ...)))
    ; Include in the output list only those elements expr for which pred? is true
    ((_ acc exp pred? rest ...)
     (if pred?
         (internal-list-of acc exp rest ...)
         acc))
    ; Base case :)
    ((_ acc exp)
     (cons exp acc))))

; Examples and tests:

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
