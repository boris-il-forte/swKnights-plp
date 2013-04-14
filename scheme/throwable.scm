#lang racket

(provide $
         new-throwable
         new-exception)

;) syntactic sugar
(define-syntax $
   (syntax-rules (->)
     [(_ object -> method args ...)
      (object 'method args ...)]))
     

;) the throwable object constructor
(define (new-throwable type message)
  (define (get-message)
    message)
  (define (get-type)
    type)
  (define (same-type? e)
    (eq? type 
         ($ e -> get-type)))
  (define (display-message)
    (display message)) 
  (λ (method . args)
    (apply (case method
               ((get-message) get-message)
               ((get-type) get-type)
               ((same-type?) same-type?)
               ((display-message) display-message)
               (else (error "Unknown Method!")))
            args)))
     
;) the exception constructor
(define (new-exception message)
  (new-throwable 'exception message))



;) debug code (commented-out... very bad! :( )

;(define e (new-exception "exceptional!"))
;(define t (new-throwable 'throwable "exceptional!"))

;($ e -> get-type)
;(newline)
;($ e -> same-type? e)
;(newline)
;($ e -> same-type? t)
;(newline)
;($ e -> get-message)
;(newline)
;($ e -> display-message)
     
    