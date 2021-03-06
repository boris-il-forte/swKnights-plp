#lang racket
;________________________FUNZIONI UTILITARIE________________________________________
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
        [(< ((car ls1) 'get-id) ((car ls2) 'get-id)) (cons (car ls1) (merge (cdr ls1) ls2))]
        [(<= ((car ls2) 'get-id) ((car ls1) 'get-id)) (cons (car ls2) (merge (cdr ls2) ls1))]))

(define (index-book-merge-sort ls)
  (if (<= (length ls) 1)
      ls
      (merge (index-book-merge-sort (car (split ls))) (index-book-merge-sort (cdr (split ls))))))



;_______________________MACRO....A NOI PIACE IL WHILE :D________________________________

(define after-while #f) ;qua si salva la continuazione: quello che avviene dopo il while

(define-syntax while
  (syntax-rules ()
    ((_ condition body ...)
     (call/cc (lambda (exit)
                (set! after-while exit)
                (let loop ()
                  (when condition
                    (begin
                      body ...
                      (loop)
                      ))))))))
(define-syntax break!
  (syntax-rules ()
    ((_)
     (after-while))))

(let ((a 10))
  (while (> a 0)
         (display a) (newline)
         (when (= a 5) (break!))
         (set! a (- a 1))))

        


    
;____________________ITERATORE SU LISTE_______________________
 
(define (make-list-iterator list)
  (lambda ()
      (if (null? list)
          '<<end>>
          (let ((top (car list)))
            (set! list (cdr list))
            top))))
                  
;-------------------DA QUA INIZIA LA RUBRICA-------------------------------------------

;Oggetto contatto della rubrica
(define (make-contact n)
  (let ((id n) (cell 0))
    (define get-id
      (lambda ()
        id))
    (define number-set!
      (lambda (num)
        (set! cell num)))
    (define get-cell
      (lambda ()
        cell))
    (lambda (message . args) ;serve per eseguire il metodo corretto in base al tipo di "messaggio" (richiesta di metodo) ricevuto
      (apply (case message
               ((get-id) get-id)
               ((number-set!) number-set!)
               ((get-cell) get-cell)
               (else (error "no such method")))
             args))))
    

;Creiamo la rubrica che incapsula una lista di contatti
(define (make-index-book)
  (let ((contacts '()))
    (define add-contact
      (lambda (c)
        (set! contacts (cons c contacts)) #t))
    
    (define remove-contact!
      (lambda (c)
        (let ((new-list '()))
          (for-each (lambda (k)
                      ;#FOR DEBUG(display (k 'get-id)) (display (c 'get-id)) (newline)
                      (when (not (= (k 'get-id) (c 'get-id)))
                        (set! new-list (cons k new-list)))) contacts)
        (set! contacts new-list))))
    
    (define order-contact-by-id!
      (lambda ()
        (set! contacts (index-book-merge-sort contacts))))
          
      
    (define show-contacts
        (lambda ()
          (for-each (lambda (x)
                      (display (x 'get-id))(newline)) contacts)))
      (lambda (message . args)
        (apply (case message
                 ((add-contact) add-contact)
                 ((remove-contact) remove-contact!)
                 ((show-contacts) show-contacts)
                 ((order-contact-by-id!) order-contact-by-id!)
                 (else (error "no such method"))) 
               args))))
  
        
(define c (make-contact 0))
(define c1 (make-contact 1))
(define c3 (make-contact 5))
(define c4 (make-contact 3))
(define r (make-index-book))

(r 'add-contact c)
(r 'add-contact c1)
(r 'add-contact c3)
(r 'add-contact c4)


             
    

