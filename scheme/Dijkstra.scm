#lang racket

(require data/heap) ;) to implement basic min-priority queue

;) The while-not cycle (it's cool)
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
      (cond [(eq? cost-a 'inf) #f]
            [(eq? cost-b 'inf) #t]
            [else (< cost-a cost-b)]))))

;) Initialization function for parents and path-cost
(define (initialize g s)
  (let ([path-cost (make-hash)]
        [parent (make-hash)])
    (begin
      (for-each (λ (n)
                  (for-each (λ (m)
                              (let ([hash (car m)]
                                    [symbol (cdr m)])
                                (hash-set! hash (node-name n) symbol)))
                            (list (cons path-cost 'inf) (cons parent (node-name s)))))
                g)
      (hash-set! path-cost (node-name s) 0)
      (list path-cost parent))))

;) Initilization for the min-priority queue
(define (initialize-queue g path-cost)
  (let ([queue (make-heap (get-order-nodes path-cost))])
    (begin
      (heap-add-all! queue g)
      queue)))


;) Update the cost and the parent of the sons
(define (update-cost current path-cost parent)
  (let* ([current-name (node-name current)]
         [current-cost (hash-ref path-cost current-name)])
    (for-each (λ (x)
                (let ([new-cost (+ current-cost (cdr x))]
                      [old-cost (hash-ref path-cost (node-name (car x)))]
                      [x-name (node-name (car x))])
                  (when (or (eq? old-cost 'inf) 
                            (< new-cost old-cost))
                    (begin                  
                      (hash-set! path-cost ;)  the cost hash table
                                 x-name ;) the name of the node
                                 new-cost) ;) the updated cost of the arc
                      (hash-set! parent ;) the parent hash table
                                 x-name ;) the name of the node
                                 current-name))))) ;) the updated parent of the arc
              (node-sons current))))


;) Dijkstra Algorithm
(define (dijkstra g s)
  (let* ([init (initialize g s)]
         [path-cost (car init)]
         [parent (cadr init)])
    (let ([current s]
          [queue (initialize-queue g path-cost)])
      (while-not (= (heap-count queue) 0)
                 ;( debug code
                 (display (node-name (heap-min queue)))
                 (display " ")
                 (display (hash-ref path-cost (node-name (heap-min queue))))
                 (display " ")
                 (display (hash-ref parent (node-name (heap-min queue))))
                 (newline)
                 ;( debug end
                 (update-cost current path-cost parent)
                 (set! current (heap-min queue))
                 (heap-remove-min! queue)))))

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

;) test the algorithm
(dijkstra graph1 (car graph1))       

