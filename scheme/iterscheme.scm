#lang racket

;; Versione leggermente diversa dalle soluzioni di Pradella

;; a) Define an iterator for lists in Scheme, such that calling it 
;; returns an element. When there are no more elements, 
;; it returns symbol <<end>>.

(define (make-list-iter list)
  (lambda ()
    (if (empty? list)
        '<<end>>
        (let ((x (car list)))
          (set! list (cdr list))
          x))))

(define il (make-list-iter '(1 2)))
(il) ; returns 1
(il) ; returns 2
(il) ; returns <<end>>

;; b) Define an analogous iterator for vectors.

(define (make-vec-iter vect)
  (let ((i 0)
        (len (vector-length vect)))
    (lambda ()
      (if (= i len)
          '<<end>>
          (let ((ret (vector-ref vect i)))
            (set! i (+ i 1))
            ret)))))

(define iv (make-vec-iter #(1 2)))
(iv) ; returns 1
(iv) ; returns 2
(iv) ; returns <<end>>

;; c) Define a new construct "for/in" which iterates on lists or vectors.

(define (make-iter iterable)
  (cond [(vector? iterable) (make-vec-iter iterable)]
        [(list? iterable) (make-iter iterable)]
        [else (error "Wrong parameter!")]))

(define-syntax for
  (syntax-rules (in)
    ((_ x in iterable block ...)
     (let ((it (make-iter iterable)))
       (let loop ((elem (it)))
         (when (not (eq? '<<end>> elem))
             (begin
               ((lambda (x) block) elem) ...
               (loop (it)))))))))

;; E.g. 
(for x in '(1 2 3) (display x)) ; shows 123
(newline)
(for x in '#(c a s a) (display x)(display ".")) ; shows c.a.s.a. 