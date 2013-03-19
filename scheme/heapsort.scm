#lang racket

(define (vector-exchange! vector x y)
  (let ((vx (vector-ref vector x))
        (vy (vector-ref vector y)))
    (begin
      (vector-set! vector x vy)
      (vector-set! vector y vx)
      vector)))
            

(define (max-heapify! heap heap-size i)
  (let ((l (* 2 i))
        (r (+ (* 2 i) 1)))
    (let ((max 
           (if (and (<= l heap-size) 
                    (> (vector-ref heap (- l 1))
                       (vector-ref heap (- i 1))))
               l
               i)))
      (begin
        (when (and (<= r heap-size)
                 (> (vector-ref heap (- r 1))
                    (vector-ref heap (- max 1))))
            (set! max r))
        (when (not (= max i))
          (begin
            (vector-exchange! heap (- max 1) (- i 1))
            (max-heapify! heap heap-size max)))))))

(define (build-max-heap! heap)
  (let ((heap-size (vector-length heap)))
    (let label ((i (quotient heap-size 2)))
      (when (> i 0)
          (begin
            (max-heapify! heap heap-size i)
            (label (- i 1)))))))

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

(define v (vector 51 561 56 1561 56 15 486 483 464 848 4898))
(display "v prima di essere riordinato ")
(display v)
(newline)
(heapsort! v)
(display "v dopo l'ordinamento ")
(display v)
      
  
        
    

                      
          
        