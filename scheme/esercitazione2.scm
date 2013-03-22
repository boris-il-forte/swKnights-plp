#lang racket

;) applicare la map ad un vettore
(define (my-map-vector v f)
  (let loop ([pos 0])
    (if (< pos (vector-length v))
        (cons (f (vector-ref v pos)) (loop (+ pos 1)))
        '())))

(define (make-matrix max-rows max-cols fill)
  (let ([vec (make-vector max-rows #f)])
    (let loop ([x 0])
      (if (< x max-rows)
          (begin 
            (vector-set! vec x (make-vector max-cols fill))
            (loop (+ x 1)))
          vec))))
      
;) foreach: applica la funzione ma non ritorna la nuova lista
(define (count-nodes f) 
  (define stack0 (list f)) ;costruisco una lista se passo un elemento il riferimento rimane sullo stack locale ma il valole è in heap
  (let loop ([stack (cdr stack0)]
             [res 1] ; contatore degli elementi
             [curr (car stack0)])
             (display stack) ;xD suuuuca
             (newline)
    (if (list? curr)
        (for-each (lambda (x)
                    (set! stack (cons x  stack)))
                    (cdr curr))
        '())
    (if (null? stack)
        res
        (loop (cdr stack)
              (+ res 1)
              (car stack)))))


;O insieme potenza

(define (all-subsets xs)
  (if (null? xs)
      '(()) ;D ritorno una lista con dentro un insieme vuoto
      (append
       (all-subsets (cdr xs))
       (map (lambda (subset) 
              (cons (car xs) subset))
            (all-subsets (cdr xs))))))

;/ VERSIONE EFFICIENTE DA PRO
(define (all-subsets2 xs)
  (if (null? xs)
      '(())
      (let ([subsets (all-subsets2 (cdr xs))])
        (append
         (subsets
          (map (λ (subset)
                 (cons (car xs) subset))
               subsets))))))

;S Struct
;p sintassi: (struct person ( name last-name age))

(struct event
  (x y name (participants #:mutable)))

(define (assert c)
  (unless c ;if negato senza else
    (error "assertion failed")))

(define (print-event e)
  (assert (event? e))
  (display (event-name e))
  (display ": coord(")
  (display (event-x e))
  (display ",")
  (display (event-y e))
  (display (event-participants e))
  (newline)
  )

(define event-list '())

(define (add-event-to-list event)
  (set! event-list (cons event event-list)))

(define (print-all-events)
  (for-each print-event event-list))

(define (event-distance-from e x y)
  (assert (event? e))
  (let ([e-x (event-x e)]
        [e-y (event-y e)]
        [^2 (λ (x) (* x x))])
    (sqrt (+ (^2 (- e-x x)) (^2 (- e-y y))))))

(define (events-close-to x y range)
  (let ([close? (λ (e) (< (event-distance-from e x y) range))])
    (filter close? event-list)))

;f mACRo

(define-syntax if:
  (syntax-rules (then: else:) ;O parole chiave
    ([if: e1 then: e2 else: e3]
     (if e1 e2 e3))))

(define-syntax my-max
  (syntax-rules ()
    [(_ a b)
     (if (> a b)
         a
         b)]))

(define-syntax my-max2
  (syntax-rules ()
    [(_ a b)
     (let ((new-a a)
           (new-b b))
           (if (> new-a new-b) new-a new-b))]))