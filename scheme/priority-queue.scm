#lang racket

;) Swap two vector elements
(define (vector-swap! v x y)
  (let ((tmp (vector-ref v x)))
    (vector-set! v x (vector-ref v y))
    (vector-set! v y tmp)
    v))

;) heapify function (max or min depending of orderer) 
(define (heapify! heap heap-size i orderer)
  (let ([l (* 2 i)]
        [r (+ (* 2 i) 1)])
    (let ((max1 
           (if (and (<= l heap-size) 
                    (orderer (vector-ref heap (- l 1))
                             (vector-ref heap (- i 1))))
               l
               i)))
      (let ((max2
             (if (and (<= r heap-size)
                      (orderer (vector-ref heap (- r 1))
                               (vector-ref heap (- max1 1))))
                 r
                 max1)))
        (when (not (= max2 i))
          (begin
            (vector-swap! heap (- max2 1) (- i 1))
            (heapify! heap heap-size max2 orderer)))))))

;) Min priority queue object
(define (make-priority-queue orderer max-size)
  (let ([queue (make-vector max-size)]
        [size 0])
    ;) Extract the firs element of the queue 
    (define (extract)
      (if (< size 1)
          (error "heap underflow")
          (let ([max (vector-ref queue 0)])
            (begin
              (set! size (- size 1))
              (vector-set! queue 0 (vector-ref queue size))
              (heapify! queue size 1 orderer)
              max))))
    ;) Private change key method, performs swap without checking
    (define (change-key-private index key)
      (begin
        (vector-set! queue (- index 1) key)
        (let loop ([i index])
          (when (and (> i 1)
                     (orderer (vector-ref queue (- i 1))
                              (vector-ref queue (- (quotient i 2) 1))))
                     (begin
                       (vector-swap! queue (- i 1) (- (quotient i 2) 1))
                       (loop (quotient i 2)))))))
    ;) Change key value, only following the ordering (if ordering is max, the key must be min)
    (define (change-key index key)
      (if (orderer (vector-ref queue index) key)
          (error "invalid new key value")
          (change-key-private index key)))
    ;) Insert a new object in the queue
    (define (insert key)
      (begin
        (vector-set! queue size 'inf)
        (set! size (+ size 1))
        (change-key-private size key)))
    ;) Insert all the elements from a list into the queue
    (define (insert-all list)
      (unless (empty? list)
          (let ([head (car list)]
                [rest (cdr list)])
            (insert head)
            (insert-all rest))))
    ;) Object message dispatcher
    (λ (method . args)
      (apply (case method
               ((extract) extract)
               ((change-key) change-key)
               ((insert) insert)
               ((insert-all) insert-all)
               (else (error "Unknown Method!")))
             args))))
                  




;) Debug code
;(define coda1 (make-priority-queue < 20))
;(coda1 'insert-all '(5 6 45 85 96 33 45 78 42 42 456))

;(newline)

;(coda1 'extract)
;(coda1 'extract)
;(coda1 'extract)



              
               
            
                     
                     