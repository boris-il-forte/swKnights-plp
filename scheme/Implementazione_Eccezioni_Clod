#lang racket

;################################
;# GESTIONE ECCEZIONI IN SCHEME #
;################################

;##########################################################################################################
;# Le eccezioni sono in questa particolare implementazione viste come stringhe                            #
;# dove il nome della stringa rappresenta il tipo di eccezione (Volendo si potevano usare anche i simboli)#
;##########################################################################################################

;pila contenente i gestori delle eccezioni
(define *handlers* (list))

;pila contenente le eccezioni che vogliamo gestire
(define *exceptions* (list))

;una push per gli handlers
(define (push-handler proc)
  (set! *handlers* (cons proc *handlers*)))

;una pop per gli handlers
(define (pop-handler)
  (let ((h (car *handlers*)))
    (set! *handlers* (cdr *handlers*))
    h))

;una push per le eccezioni
(define (push-exception ex)
  (set! *exceptions* (cons ex *exceptions*)))

;una pop per le eccezioni
(define (pop-exception)
  (let ((e (car *exceptions*)))
    (set! *exceptions* (cdr *exceptions*))
    e))

;funzioni ausiliarie per le liste *exceptions* e *handlers* 
(define (more-handlers?) (pair? *handlers*))

(define (more-exceptions?) (pair? *exceptions*))

;Percorre lo stack delle eccezioni e se ne trova una corrispondente allora ritorna vero... in caso contrario falso
;Il metodo lavora in modo da mantenere allineati *handlers* e *exceptions*. Quando viene ritornato vero, dallo stack *handlers*
;non viene prelevato l'handler corrispondente, e le due pile risultaranno sfasate di uno fino a quando nel throw corrispondente
;non viene poppato ed eseguito
(define (same-exception? ex)
    (if (not (more-exceptions?))
        #F
        (if (string=? ex (pop-exception))
            #T ; nel caso si ritorni true, non viene poppato l'handler che verrà successivamente preso e usato nel catch
            (begin
              (pop-handler)
              (same-exception? ex))))) ;pop handler in quanto le due pile (handlers & exceptions) devono rimanere allineate
  
;_______________________________________________________________



;Procedura che lancia un'eccezione (UNA SOLA) ed eventualmente la gestisce
(define (throw e)
  (if (same-exception? e)
      ((pop-handler))   ;alla prima occorrenza della stessa eccezione trovata ne viene eseguito l'handler
      (error (string-append "non hai gestito l'" e)))) ;se non ci sono eccezzioni dello stesso tipo in pila si avrà un errore

;Il catch è molto simile a quello visto a lezione, l'unica differenza sta nel fatto che ora dobbiamo gestire anche la pila delle
;eccezioni: ogni volta che si fa un push di un handler lo si fa anche per l'eccezione, e lo stesso vale per i pop (ovvero gli scarti)
(define-syntax catch
  (syntax-rules ()
    ((_ exception handler exp1 ...)
     (call/cc (lambda (exit) ;preinstallo l'handler e la rispettiva eccezione che gestisce
                (push-exception exception)
                (push-handler (lambda ()
                                (exit handler)))
                (let ((res
                       (begin exp1 ...)))
                  (pop-handler) ;scarto handler e eccezione che non servono piu'
                  (pop-exception)
                  res))))))

;Come intuitivo il catch funziona nel modo seguente: come argomenti prende rispettivamente l'eccezione da gestire (sottoforma di
;stringa), il gestore dell'eccezione il quale è una sequenza di istruzioni o una procedura, e una serie di istruzioni che di fatto
;rappresenterebbero il blocco try in java.
;Per chiarezza:
; (catch "eccezione" (begin ...handler...) (exp1) (exp1) ...)
;qualora venisse lanciata un'eccezione verrebbe attivato il rispettivo handler in pila o in alternativa verrebbe lanciato un errore
;la gestione è componibile, ovvero un'eccezione lanciata in un catch piu' interno puo' essere gestita dal'handler posto da un catch
;piu' esterno ad esso.

;Esempio di utilizzo: catch nidificati
(define (foo x)
  (display x) (newline)
  (throw "eccezione_1"))

(catch "eccezione_1" (display "presa eccezione_1\n") 
  
  
  (catch "eccezione_1" (display "presa eccezione_1 da interno\n")
    (display "prima di foo\n")
    (foo "CIAO!!\n"))
  (foo "CIAO_2\n")
  (display "dopo foo")) ;non raggiungibile
  
           
  
  
  
  
    
  
  
  
  
  
  

