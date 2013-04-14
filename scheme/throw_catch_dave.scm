#lang racket

(provide throw
         try)


;) the handler list
(define *handlers* (list))

;) function to push a handler/exception pair
(define (push-handler proc exception)
  (set! *handlers*
        (cons (cons proc exception) *handlers*)))

;) function to push a start/try marker
(define (push-marker)
  (push-handler '() '<<!!marker!!>>))

;) function to pop an handler/exception pair
(define (pop-handler)
   (let ((h (car *handlers*)))
      (set! *handlers* (cdr *handlers*))
      h))
  
;) function to pop until a start/try marker (to clean the handler stack)
(define (pop-marker)
  (let loop ([h (pop-handler)])
    (unless (eq? (cdr h) '<<!!marker!!>>)
      (loop (pop-handler))))) ;) loop until the handler is clean
  

;) throw function
(define (throw e)
  (if (pair? *handlers*)
      (let ([handler-exception (pop-handler)]) ;) gets the handler/exception pair
        (if (equal? (cdr handler-exception) e) ;) if the exception is the same...
            ((car handler-exception)) ;) ... handle the exception
            (throw e))) ;) ... else propagate it!
      (error e))) ;) no handlers found, show an error...

;) internal macro...
(define-syntax internal-try
  (syntax-rules (catch)
    [(_ exp1 ... [(catch exception handler)] exit)
     (let ([new-handler (λ ()
                          (exit handler))]) ;) generate the handler
       (push-handler new-handler exception) ;) install the handler
       (let ((res ;) evaluate the body
              (begin exp1 ...)))
         (pop-handler) ;) ok: discard the handler
         res))]
    
    [(_ exp1 ... [(catch exception1 handler1) (catch exception2 handler2) ...] exit)
     (let ([new-handler1 (λ () 
                          (exit handler1))]) ;) generate the handler
       (push-handler new-handler1 exception1) ;) install the handler
       (let ([res 
              (internal-try exp1 ... [(catch exception2 handler2) ...] exit)]) ;) recursive call of the internal macro
         (pop-handler) ;) ok: discard the handler
         res))])) 

;) the try/catch syntax
(define-syntax try
  (syntax-rules (catch)
    [(_ exp1 ... [(catch exception handler) ...])
      (let ([res (call/cc (λ (exit)
                  (push-marker) ;) put the marker of the starting try
                  (internal-try exp1 ... [(catch exception handler) ...] exit)))]) ;) calls the internal macro
       (pop-marker) ;) clean the handler's stack
       res)]))  ;) return value


;) debug 1
(try (display "banale...") 
     [(catch '() (display 1))
      (catch '() (display 2))
      (catch '() (display 3))]) 

(newline)
*handlers*

;) debug 2
(try (throw "ciao")
     ([catch "ciao" (display "ciao")]
      [catch "bum!" (display "esplode!")]))

(newline)
*handlers*

;) debug 3
(try
 (try (throw 'unhandled)
     ([catch "ciao" (display "ciao")]
      [catch "bum!" (display "esplode!")]))
 ([catch 'unhandled (display "beccata!")]))

(newline)
*handlers*

;) debug 4
(try (throw "bum!")
     ([catch "ciao" (display "ciao")]
      [catch "bum!" (display "esplode!")]))

(newline)
*handlers*

;) debug 5
(+ 2 (try (throw "bum!")
          ([catch "ciao" 4]
           [catch "bum!" 5])))

(newline)
*handlers*

;) debug 6
(try
 (try
  (try (throw 42)
       ([catch "ciao" (display "ciao")]
        [catch "bum!" (display "esplode!")]
        [catch 42 (begin (display "primo catch") (newline) (throw 42) (newline))]))
  ([catch 'unhandled (display "unhandled")]))
 ([catch 42 (display "beccato il 42!")]
  [catch 74 (display "74")]))

(newline)
*handlers*


;) debug 7
(try (display (+ 40 1 1))
     (display " debug complesso...")
     (throw "bum!")
     ([catch "ciao" (display "ciao")]
      [catch "bum!" (begin
                      (display " esplode! ")
                      (display (- 50 8)))]))

(newline)
*handlers*

;) debug with error (but it's correct xD) so commented-out (evil!)
;(try (throw 'unhandled)
 ;    ([catch "ciao" (display "ciao")]
  ;    [catch "bum!" (display "esplode!")]))