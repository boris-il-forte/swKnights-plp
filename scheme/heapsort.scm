#lang racket

;) Scambia due elementi di un vettore
(define (vector-exchange! v x y)
  (let ((tmp (vector-ref v x)))
    (vector-set! v x (vector-ref v y))
    (vector-set! v y tmp)
    v))

;) Trasforma  un heap in un max heap 
(define (max-heapify! heap heap-size i)
  (let ((l (* 2 i))
        (r (+ (* 2 i) 1)))
    (let ((max1 
           (if (and (<= l heap-size) 
                    (> (vector-ref heap (- l 1))
                       (vector-ref heap (- i 1))))
               l
               i)))
      (let ((max2
        (if (and (<= r heap-size)
                 (> (vector-ref heap (- r 1))
                    (vector-ref heap (- max1 1))))
          r
          max1)))
        (when (not (= max2 i))
          (begin
            (vector-exchange! heap (- max2 1) (- i 1))
            (max-heapify! heap heap-size max2)))))))

;) Costruisce un max-heap da un vettore qualunque 
(define (build-max-heap! heap)
  (let ((heap-size (vector-length heap)))
    (let label ((i (quotient heap-size 2)))
      (when (> i 0)
          (begin
            (max-heapify! heap heap-size i)
            (label (- i 1)))))))

;) Algoritmo Heapsort
(define (heapsort! heap)
  (begin
    (build-max-heap! heap)
    (let ((heap-size (vector-length heap)))
      (let label ((i heap-size))
        (set! heap-size (- heap-size 1))
        (max-heapify! 
         (vector-exchange! heap 0 (- i 1))
         heap-size
         1)
      (when (> i 1)
        (label (- i 1)))))))

;) Prova l'algoritmo
(define v (vector 51 561 56 1561 56 15 486 483 464 848 4898))
(display "v prima di essere riordinato ")
(display v)
(newline)
(heapsort! v)
(display "v dopo l'ordinamento ")
(display v)