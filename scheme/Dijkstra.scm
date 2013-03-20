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

;) A routine to get the index from the char
(define (get-index c)
  (- (char->integer c) 97))

;) A test graph
(define graph1
  (let ((a (node #\a '()))
        (b (node #\b '()))
        (c (node #\c '()))
        (d (node #\d '()))
        (e (node #\e '())))
    
      (set-node-sons! a (list (cons b 2) (cons c 3)))
      (set-node-sons! b (list (cons d 4) (cons e 5)))
      (set-node-sons! e (list (cons d 6)))
      (list a b c d e)))


;) Initialization function for parents and path-cost
(define (initialize g s)
  (let ((path-cost (make-hash))
        (parent (make-hash))
        (explored (set)))
    (begin
      (for-each (λ (n)
                  (for-each (λ (m)
                              (let ((hash (car m))
                                    (symbol (cdr m)))
                                (hash-set! hash (node-name n) symbol)))
                    (list (cons path-cost 'inf) (cons parent (node-name s)))))
                g)
      (list path-cost parent (set-add explored s)))))


;) Find the nearest node
;(define (find-minimum current path-cost)
  ;(for-each (λ (x) )
              ;(node-sons current))
  
  

;) Dijkstra Algorithm
;(define (dijkstra g s)
  ;(let* ((init (initialize g s))
         ;(path-cost (car init))
         ;(parent (cadr init))
         ;(explored (caddr init))
         ;(N (length g)))
    ;(let ((current s))
      ;(while-not (= (set-count explored) N)
                 ;(update-data parent path-cost current)
                 ;(set! current
                       ;(let ((tmp (find-minimum current path-cost)))
                         ;(begin
                           ;(hash-set! parent tmp current)
                           ;tmp)))
                 ;(set! explored (set-add explored))))))
        
    
;) test the algorithm
;(dijkstra graph1 (car graph1))       
    
    