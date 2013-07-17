#lang racket

; Extended throw\catch
; Marcello Pogliani <marcello.pogliani@gmail.com>, 2012/04/14

; --- USAGE ---
;
; (throw exc object):    Throws an exception of the type "exc". 
;                        The exception type must be a symbol.
;                        The object "object" is passed to the exception handler.
;                        If no suitable handler is found, then an error is 
;                        raised (i.e. (apply error object))
;
; (catch exc obj h exp1 ...): Executes the code block exp1 ..., setting up the
;                        expression h as an handler for the "exc" exception type.
;                        The expression h can make use of the 'obj' variable, 
;                        that is the object thrown at runtime.
;
; (catch-all obj h exp1 ...): Same as 'catch', but handles every exception.

(provide
 throw
 catch
 catch-all)

; An element of the *handlers* list.
; * name => the symbol identifying the exception type
; * proc => a procedure that is the actual exception handler
; * catch-all? => a flag indicating whether the handler is a catch-all.
;                 If true, name is not relevant.
(struct _handler 
  (name
   proc
   catch-all?))

; Global list of handlers, push-handler and pop-handler
; (unchanged wrt the slides)
(define *handlers* (list))

(define (push-handler proc)
  (set! *handlers* (cons proc *handlers*)))

(define (pop-handler)
  (let ((h (car *handlers*)))
    (set! *handlers* (cdr *handlers*))
    h))

; Is the handler compatible with the thrown symbol? (same symbol or catch-all)
(define (compatible? handler symbol)
  (or (_handler-catch-all? handler)
       (eq? symbol (_handler-name handler))))

; Throw is defined as an helper macro just not to quote the symbol
; indicating the exception type from application code (i.e. exc and not 'exc).
; The real work is done by the *throw* procedure, not exported by the module.
; Wrt to the slides, it accepts only two parameters (name and obj)
(define-syntax throw
  (syntax-rules ()
    ((_ name obj)
     (*throw* 'name obj))))

; Throw helper procedure. Same arguments as the throw macro, but name is quoted.
; Pops the handlers from *handler* until it finds one that compatible with
; the thrown exception. If no handler is found, an error is raised.
(define (*throw* name obj)
  (if (pair? *handlers*)
      (let ((h (pop-handler)))
        (if (compatible? h name)
            ((_handler-proc h) obj)
            (*throw* name obj)))
      (error obj)))

; Macros definition for the catch procedure. Real work done by internal-catch
(define-syntax catch
  (syntax-rules ()
    ((_ name x handler exp1 ...)
     (internal-catch #f name x handler exp1 ...))))

(define-syntax catch-all
  (syntax-rules ()
    ((_ x handler exp1 ...)
     (internal-catch #t all x handler exp1 ...))))

; Catch helper macro.
; * is-all => true if this block is a catch-all, false otherwise
; * name => symbol representing the exception type to catch, relevant
;           only if (= is-all #f)
; * e => the symbol used in the handler block for the thrown object
; * handler => handler block (expression).
; * exp1 ... => code blocks to execute inside the "catch".
; Notice: with respect to the catch macro seen on the slides, what is pushed
; on the handlers list is not a procedure, but a struct containing also 
; informations about which exceptions to catch. Now the handler block is
; wrapped in a lambda function, as it is defined in terms of the thrown object
(define-syntax internal-catch
  (syntax-rules ()
    ((_ is-all name e handler exp1 ...)
     (call/cc (lambda (exit)
                ;; install the handler
                (push-handler (_handler
                               'name
                               (lambda (object) ;; now it takes a parameter
                                 (exit ((lambda (e) handler) object)))
                               is-all))
                (let ((res ;; evaluate the body
                       (begin exp1 ...)))
                  ; ok: discard the handler
                  (pop-handler)
                  res))))))

