#lang racket

; Simple (non optimized at all) list comprehension macro for Scheme

; Example:
; (list-of (+ y 6)
;         (x range 1 6)
;         (odd? x)
;         (y is (* x x)))   ==>   '(7 15 31)
;
; Syntax and "suggestions" for the implementation stolen from:
; [1] http://wiki.call-cc.org/eggref/4/list-of
; [2] http://www.phyast.pitt.edu/~micheles/scheme/scheme17.html
; [3] https://sites.google.com/site/schemephil/list-of.html <==
; 
; NB: With respect to [2], this macro does NOT support
; comprehensions plus destructuring like:
; (list-of (+ x y) ((x y) in '((1 2)(3 4)))) => '(3 7)
;
; For "real" use, use the macro at [3]!!!

(provide list-of)

(define-syntax list-of
  (syntax-rules ()
    ((_ expr clause ...)
     (internal-list-of '() expr clause ...))))

(define-syntax internal-list-of
  (syntax-rules (in is range)

    ((_ acc exp (var in list-expr) rest ...)
     (let loop ((l list-expr))
       (if (null? l)
           acc
           (let ((var (car l)))
              (internal-list-of (loop (cdr l)) exp rest ...)))))

    ((_ acc exp (var range beg end step) rest ...)
     (let loop ((i beg))
       (if (or 
            (and (positive? step) (>= i end)) 
            (and (not (positive? step)) (< i end)))
           acc
           ((lambda (var) 
              (internal-list-of (loop (+ step i)) exp rest ...)) i))))
    
    ((_ acc exp (var range beg end) rest ...) ; default step
     (let ((step (if (< beg end) 1 -1)) (ended? (if (< beg end)
                                                   (lambda (i) (>= i end))
                                                   (lambda (i) (< i end)))))
       (let loop ((i beg))
         (if (ended? i)
             acc
           ((lambda (var) 
              (internal-list-of (loop (+ step i)) exp rest ...)) i)))))

    ((_ acc exp (var is expr) rest ...)
     (let ((var expr))
       (internal-list-of acc exp rest ...)))

    ((_ acc exp pred? rest ...)
     (if pred?
         (internal-list-of acc exp rest ...)
         acc))

    ((_ acc exp)
     (cons exp acc))))