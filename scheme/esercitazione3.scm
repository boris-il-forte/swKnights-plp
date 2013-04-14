#lang racket
;) prodotto cartesiano di liste 
;)'(a b) '( 1 2) ---> ((a 1) (a 2) (b 1) (b 2))

(define (listify x)
  (if (list? x)
      x
      (list x)))

(define (cartesian-product x y)
  (let ([val '()])
    (for-each (λ (a) 
                (for-each (λ (b) 
                            (set! val 
                                  (append val
                                          (list (append 
                                                 (listify a)
                                                 (listify b))))))
                         y))
                x)
    (display val)))

;) Macro for non e' bello creare una procedura perche'devo valutare un'espressione

(define-syntax for
  (syntax-rules (in)
    [(_ var in lst fun ...)
     (for-each (λ (var)
                 fun ...) lst)]))


; list comprension

(define (concat-map lst f)
  (apply append (map f lst)))

(define-syntax list/co
  (syntax-rules (when from)
    [(_ expr from v1 l1)
     (concat-map l1 
                 λ (v1)
                 (list expr))]
    [(_ expr from v1 l1 v2 l2 ...)
     (concat-map l1
                 (λ (v1)
                   (list/co expr from v2 l2 ...)))]
    [(_ expr when condition from v1 l1)
     (concat-map l1 
                 (λ (v1)
                   (if condition
                       (list expr)
                       '())))]
    [(_ expr when condition from v1 l1 v2 l2 ...)
     (concat-map l1
                 (λ (v1)
                   (list/co expr when  condition 
                            from v2 l2 ...)))]))

;continuation

(define *queue* '())

(define (empty-queue?)
  (null? *queue*))

(define (enqueue x)
  (set! *queue* (append *queue* (list x))))

(define (dequeue x)
  (let ([x (car *queue*)])
    (set! *queue* (cdr *queue*))
    x))

(define (fork proc)
  (call/cc
   (λ (k)
     (enqueue k)
     (proc))))


(define (yield)
  (call/cc
   (λ (k)
     (enqueue k)
     ((dequeue)))))

(define (thread-exit)
  (if(empty-queue?)
     (exit)
     ((dequeue)))) ; invoca la dequeue e invoca subito la funzione ritornata
     
     
;esempio
     
(define (do-stuff-n-print str max)
  (λ ()
    (let loop ([n 0])
      (display str)(display " ")(display n)(newline)
      (yield)
      (if 
       (< n max)
       (loop (+ 1 n))
       (thread-exit)))))