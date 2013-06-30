#lang racket
(struct handler(
  exc
  proc))

(define handlers (list))

(define (h-pop)
  (if (pair? handlers)
      (let ((h (car handlers)))
        (set! handlers (cdr handlers))
        h)
      (error "no handlers")))

(define (h-push e p)
  (set! handlers (cons (handler e p) handlers)))

(define (handled? e h)
    (eq? e (handler-exc h)))
        

(define (throw e)
  (display handlers)
  (newline)
  (if (pair? handlers)
      (let ((h (h-pop)))
        (if (handled? e h)
            ((handler-proc h))
            (throw e)))
  (error (string-append "uncaughted exception: " e))))

(define-syntax catch
  (syntax-rules ()
    ((_ exc proc body1 ...)
     (call/cc (λ(exit)
                (h-push exc (λ() (exit proc)))
                (let ((res
                       (begin body1 ...)))
                  (h-pop)
                  res))))))
                 
