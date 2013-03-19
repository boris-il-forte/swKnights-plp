#lang racket

(define (fac n)
  (if (= n 0)
      1
      (* (fac (- n 1)) n))
  )
(display (fac 5))

;liste!  ma sei in lista???

(cons 1 2)

(define (len l)
  ;lista vuota?
  (if (null? l)
      0
      (+ 1 (len (cdr l)))
      )
  )

(display (len '(1 2 3 "suca!")))

(define (sequence lo hi)
  (if (> lo hi)
      (error "suca! --  lo > hi")
      (if (< lo hi)
          (cons lo (sequence (+ lo 1) hi))
          (cons lo '()))))
(newline) (newline)    
(sequence 3 12) 


(define (fff a)
  (cond ((> a 5) "suca5")
        ((= a 6) "suca6")
        ((= a 7) "suca 7")
        (else "ma che ca' dici??")
        ))

(fff 6)  
(fff -20)

;fib (n) = fib(n-1) + fib(n-2)
(define (fib1 n) 
  (cond [(= n 0) 0]
        [(= n 1) 1]
        [else (+ (fib1 (- n 1)) (fib1 (- n 2) ) )]))

(define (fib2 n)
  (let fib[(i n)
    (fn-1 0)
    (fn-2 1) ]
    
    (if (= i 0)
       fn-1
       (fib (- i 1) 
            (+ fn-1 fn-2) 
            fn-1))))
       
(fib2 8)    
     
(display (fib1 30))

;lista
;somma di elementi di  liste gerarchiche a piacere

(define (sumlist l)
  (cond [(null? l) 0]
        [(list? (car l)) (+ (sumlist (car l) (sumlist (cdr l))))]
        [else (+ car l) (sumlist (cdr l))])) 
                                                  

(define (sumlist2 l)
  (cond [(null? l) 0]
        [(list? (car l)) (+ (sumlist2 (car l) (sumlist2 (cdr l))))]
        [(number? (car l)) (+ car l) (sumlist2 (cdr l))]
        [else (sumlist2 (cdr l))]))

(define (my-map l f)
  (if (null? l)
      '()
      (cons (f (car l)) (my-map (cdr 1) f))))



                                                      
                                                      
                                                      
                                                      
                                                      