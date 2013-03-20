#lang racket

(define (split ls)
  (letrec ((split-h (λ (ls ls1 ls2)
                      (if (or (null? ls) (null? (cdr ls)))
                          (cons (reverse ls2) ls1)
                          (split-h (cddr ls) (cdr ls1) (cons (car ls1) ls2))))))
    (split-h ls ls '())))

(define (merge ls1 ls2)
  (cond [(and (null? ls1) (null? ls2)) '()]
        [(null? ls1) ls2]
        [(null? ls2) ls1]
        [(< (car ls1) (car ls2)) (cons (car ls1) (merge (cdr ls1) ls2))]
        [(<= (car ls2) (car ls1)) (cons (car ls2) (merge (cdr ls2) ls1))]))

(define (merge-sort ls)
  (if (<= (length ls) 1)
      ls
      (merge (merge-sort (car (split ls))) (merge-sort (cdr (split ls))))))
       
  

        
      
      
                  



                    
          
   
    

