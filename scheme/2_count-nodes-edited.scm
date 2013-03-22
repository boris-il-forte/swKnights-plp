#lang racket

; Counts the number of elements within an arbitrarily nested list
; (count-nodes '(1 2 3 (+ 4 5))) => 6

; Versione del count-nodes fatto a lezione che non dovrebbe presentare il bug
; per cui (= (count-nodes '((+ 1 2 3) 4 5)) 3)
; Potrei ovviamente avere introdotto altri bug :P

(define (count-nodes l)
;  (define stack0 (list l))
  (let loop ([stack '()]
             [res 1]
             [curr l])
    (cond
      ([list? curr] (begin
                      (for-each (lambda (x) 
                                  (set! stack (cons x stack)))
                                curr)
                      (loop (cdr stack)
                            res ; non incrementa 'res' quando curr e' una lista e quindi i suoi elementi sono stati messi nello stack
                            (car stack))))
      ([null? stack] res)     ; curr e' un elemento SINGOLO ed e' l'ultimo
      (else (loop (cdr stack) ; curr e' un elemento SINGOLO e non e' l'ultimo
                  (+ 1 res)
                  (car stack))))))

; Valori di test

(count-nodes '('1 '2 '3)) ; ==> 6 (nell'originale ritornava 5)
(count-nodes '(1 2 3 (+ 4 5))) ; ==> 6 
(count-nodes '((+ 4 5) 1 2 3)) ; ==> 6 (nell'originale ritornava 4)
(count-nodes '(1 2 (+ 3 (- 2 3) (* 4 5 (prova prova prova))) 4)) ; ==> 14
(count-nodes '((+ 1 2 3 4 5) '2 '3)) ; ==> 10 (nell'originale ritornava 5)
(count-nodes '((+ 1 2 3 4 5) (+ 2 3 4) ((+ 1 2) 3))) ; ==> 14 (nell'originale ritornava 7, venivano considerati sia (+ 1 2 3 4 5)  che (+ 1 2) come un unico elemento)
