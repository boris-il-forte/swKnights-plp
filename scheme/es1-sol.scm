#lang racket

; This file contains a tentative solution of the exercises 
; proposed by the teacher during the first exercise lecture

; 0.
; Rewrite function my-map using a named let.

(define (my-map-2 l f)
    (let loop ((lst l))
      (if (null? lst) 
          '()
          (cons (f (car lst)) (loop (cdr lst))))))
      
(define (square n) (* n n))
(my-map-2 '(1 2 3) square)
    

; 1. 
; Define "my-map-vector" that does the same thing of the map,
; except that it processes a vector.
; You can use the following functions (defined in the standard library):
; vector-length, vector-ref.

(define (my-map-vector-1 v f)
  (let ((temp (make-vector (vector-length v))))
  (let loop ((i 0))
    (if (= i (vector-length v))
        temp
        (begin
          (vector-set! temp i (f (vector-ref v i)))
          (loop (+ 1 i)))))))

(define (my-map-vector-2 v f)
  (let loop ((i 0))
    (if (= i (vector-length v))
        '()
        (cons (f (vector-ref v i)) (loop (+ 1 i))))))

(define (my-map-vector-3 v f)
  (list->vector(my-map-vector-2 v f)))

(my-map-vector-1 #(1 2 3) square)
(my-map-vector-2 #(1 2 3) square)
(my-map-vector-3 #(1 2 3) square)

; 2.
; Define a function "vect-to-list" that transforms a vector into a list

(define (vect-to-list v)
  (let loop ((i 0))
    (if (= i (vector-length v))
        '()
        (cons (vector-ref v i) (loop (+ 1 i))))))

(vect-to-list #(1 2 3 4 5))
(vect-to-list #())

; 3.
; Define a function "take" that accepts a non-negative number n and a list l.
; The function returns the first n elements of the list or the whole list
; if the its length is less than n.
; You can use the function "reverse" which just reverses the order of a list

(define (take n l)
  (cond [(< n 0) (error "n < 0")]
        [(or (= n 0) (null? l)) '()]
        [else (cons (car l) (take (- n 1) (cdr l)))]))

(take 1 '(1 2 3))
(take 2 '(1 2 3))
(take 3 '(1 2 3))
(take 4 '(1 2 3))

(define (my-reverse l)
  (let loop ((t '()) (r l))
    (if (null? r)
        t
        (loop (cons (car r) t) (cdr r)))))

(my-reverse '(1 2 3 4 5))
(my-reverse '())
(my-reverse '(4))

(define (take-2 n l)
  (reverse (take-last n (reverse l))))

(define (take-last n l)
  (if (and (> (length l) n))
      (take-last n (cdr l))
      l))

(take-2 1 '(1 2 3 4 5 6 7 8))
(take-2 2 '(1 2 3))
(take-2 3 '(1 2 3))
(take-2 4 '(1 2 3))
(take-2 10 '())

