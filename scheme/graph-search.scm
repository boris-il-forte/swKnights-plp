#lang racket

;) the node struct
(struct node
  (name
  (sons #:mutable)
  (color #:mutable)))

;) A test graph
(define graph1
  (let ((a (node #\a '() 'white))
        (b (node #\b '() 'white))
        (c (node #\c '() 'white))
        (d (node #\d '() 'white))
        (e (node #\e '() 'white)))
    
      (set-node-sons! a (list b c))
      (set-node-sons! b (list d e))
      (set-node-sons! e (list d))
      (list a b c d e)))
  
;) deep-first loop
(define (depth-first n)  
    (for-each (λ (x)
                (when (eq? (node-color x) 'white)
                  (begin
                    (display (node-name x))
                    (newline)
                    (set-node-color! x 'black)
                    (depth-first x))))
              (node-sons n)))

;) breadth-first loop
(define (breadth-first l)
  (unless (null? l) 
    (if (eq? (node-color (car l)) 'white)
        (begin
          (set-node-color! (car l) 'black)
          (display (node-name (car l)))
          (newline)
          (breadth-first (append (cdr l) (node-sons (car l)))))
        (breadth-first (cdr l)))))

;) Breadth first algorithm
(define (breadth-first-search g)
  (breadth-first (list (car g))))

;) Depth first algorithm
(define (depth-first-search g)
  (set-node-color! (car g) 'black)
  (display (node-name (car g)))
  (newline)
  (depth-first (car g)))

;(depth-first-search graph1)
(breadth-first-search graph1)

  


    