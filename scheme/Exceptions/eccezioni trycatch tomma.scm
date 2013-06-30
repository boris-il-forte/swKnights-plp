#lang racket
;RICCARDO TOMMASINI 799120

(struct handler (
           exc
           proc))
; lista di liste di handler
;ogni lista rappresenta il contesto di attivazione di una eccezione
(define handlers (list))

;riceve una lista l di handler che viene aggiunta al record di tutte le eccezioni 
(define (h-push l)
        (set! handlers (append  (list l) handlers)))

; pop di alto livello per la lista, restitisce un elemendo l che contiene una lista di handler
(define (high-pop)
  (if (pair? handlers)
      (let ((l (car handlers)))
        (set! handlers (cdr handlers))
        l)
      (error "no handlers")))
;zucchero sintattico per definire l'uguaglianza tra una eccezione lanciata ed una eventualemnte gestita
(define (handled? e h)
    (eq? e (handler-exc h)))
;componente inferiore del throw, permette la gestione della lista interna di handler, ed eventualmente innesca una catena ricorsiva
(define (sub_throw e l)
  (if (pair? l)
            (let ((h (car l)))
             (set! l (cdr l))
             (if (handled? e h)
                  ((handler-proc h))
                  (sub_throw e l)))
            (throw e)))

;metodo per il lancio dell'eccezione
(define (throw e)
  (if (pair? handlers)
      (let (( *handlers* (high-pop)))
        (sub_throw e *handlers*))
      (error (string-append "uncaught exception: " e))))

; macro che definisce il costrutto
(define-syntax try
  (syntax-rules ()
   ((_ body ... ((_ exc proc) ... ))
                 (call/cc (λ(exit)
                            (h-push (list (handler exc (λ() exit proc)) ...))
                            (let ((res 
                                   (begin body ...)))
                              (unless (null? handlers) (high-pop))
                              res))))))
                              
; esempio base                           
(try  (throw "e1") ((catch "e1" (display "caught e1 esempio 1\n"))))
;esempio annidato a due livelli
(try (try (throw "e2") 
        ((catch "e1" (display "caught e1\n"))))
 ((catch "e2" (display "caught e2 esempio 2\n"))))

; annidato a 3 livelli
(try (try (try (throw "e2") 
             ((catch "e1" (display "caught e1\n")))) 
       ((catch "e3" (display "caught e3\n"))))
 ((catch "e2" (display "caught e2 esempio 3\n"))))
;esempio con più costrutti di catch
(try (throw "e2")  ((catch "e1" (display "presa e1 esempio 4\n"))
                    (catch "e2" (display "presa e2 esempio 4\n"))  
                    (catch "e3" (display "presa e3 esempio 4\n"))))
;annidato con più costrutti di catch
(try 
 (try (throw "e1")  ((catch "e1" (display "presa e1 interna esempio 5\n"))
                     (catch "e2" (display "presa e2 interna esempio 5\n"))  
                     (catch "e3" (display "presa e3 interna esempio 5\n")))) 
 ((catch "e1" (display "presa e1 esterna esempio 5\n"))))

;annidato 2 livelli con più costrutti
(try
 (try 
  (try (throw "e1")  ((catch "e5" (display "presa e5 interna esempio 6\n"))
                     (catch "e2" (display "presa e2 interna esempio 6\n"))  
                     (catch "e3" (display "presa e3 interna esempio 6\n")))) 
 ((catch "e6" (display "presa e6 esterna livello 1 esempio 6\n"))))
 ((catch "e1" (display "presa e1 esterna livello 2 esempio 6\n"))
  (catch "e4" (display "presa e4 esterna livello 2 esempio 6\n"))))

;esempio eccezione non catchata

;(throw "e1")

(try (throw "e")  ((catch "e1" (display "presa e1 esempio 4\n"))
                    (catch "e2" (display "presa e2 esempio 4\n"))  
                    (catch "e3" (display "presa e3 esempio 4\n"))))