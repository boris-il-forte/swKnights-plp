#lang racket

;) The while cycle (it's cool)
(define-syntax while-not
  (syntax-rules ()
    (( _ condition body ...)
     (let loop ()
       (when (not condition)
         (begin
            body ...
            (loop)))))))

;) The node struct
(struct node
  (name
  (sons #:mutable)))

;) Creates a routine for ordering nodes, using closures
(define (get-order-nodes path-cost)
  (λ (node-a node-b)
    (let* ([a (node-name node-a)]
           [b (node-name node-b)]
           [cost-a (hash-ref path-cost a)]
           [cost-b (hash-ref path-cost b)])
      (< cost-a cost-b))))

;) A routine to get the index from the char
(define (get-index c)
  (- (char->integer c) 97))

;) A test graph
(define graph1
  (let ([a (node #\a '())]
        [b (node #\b '())]
        [c (node #\c '())]
        [d (node #\d '())]
        [e (node #\e '())])
    
      (set-node-sons! a (list (cons b 2) (cons c 3)))
      (set-node-sons! b (list (cons d 4) (cons e 5)))
      (set-node-sons! e (list (cons d 6)))
      (list a b c d e)))


;) Initialization function for parents and path-cost
(define (initialize g s)
  (let ([path-cost (make-hash)]
        [parent (make-hash)]
        [explored (set)])
    (begin
      (for-each (λ (n)
                  (for-each (λ (m)
                              (let ([hash (car m)]
                                    [symbol (cdr m)])
                                (hash-set! hash (node-name n) symbol)))
                    (list (cons path-cost 'inf) (cons parent (node-name s)))))
                g)
      (list path-cost parent (set-add explored s)))))

;) Initilization for the min-priority queue
(define (initialize-queue g path-cost)
  (let ([queue (make-heap (get-order-nodes path-cost))])
    (begin
      (for-each (λ (x)
                  (heap-add-all! queue g)))
      queue)))
         

;) Update the cost and the parent of the sons
(define (update-cost current path-cost parent)
  (let* ([current-name (node-name current)]
         [current-cost (hash-ref path-cost current-name)])
    (for-each (λ (x)
                (let ([new-cost (+ current-cost (cdr x))])
                  (when (> new-cost 
                           (hash-ref path-cost (car x)))
                    (begin                  
                      (hash-set! path-cost ;)  the cost hash table
                                 (node-name (car x)) ;) the name of the node
                                 new-cost) ;) the updated cost of the arc
                      (hash-set! parent current)))))
              (node-sons current))))
                    

;) Dijkstra Algorithm
(define (dijkstra g s)
  (let* ([init (initialize g s)]
         [path-cost (car init)]
         [parent (cadr init)]
         [explored (caddr init)]
         [N (length g)])
    (let ([current s]
          [queue (initialize-queue g path-cost)])
      (while-not (= (set-count explored) N)
                 (update-cost current path-cost parent)
                 (set-add explored current)
                 (set! current (in-heap/consume! heap))))))
                 
                                
;) test the algorithm
(dijkstra graph1 (car graph1))       
    
    