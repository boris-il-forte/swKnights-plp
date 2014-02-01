#lang racket

;Define an iterator for lists in Scheme, such that calling it returns an element. When there are no more elements, it returns
;symbol <<end>>

(define (iter-list lst)
  (let ((cur lst))
    (lambda ()
      (if (null? cur)
          '<<end>>
          (let ((v (car cur)))
            (set! cur (cdr cur))
            v)))))

(define (iter-vector vct)
  (let ((head (vector-ref vct 0)))
    (lambda ()
      (if (null? head)
          '<<end>>
          (let ((elem head) (index 1))
            (set! head (vector-ref index))
            (set! index (+ 1 index))
            elem)))))
        
        
     
(define v-iterator (iter-vector #(1 2 3)))

(define iterator (iter-list '(1 2 3)))


  



