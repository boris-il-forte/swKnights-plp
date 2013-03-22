#lang racket

; Count nodes ricorsivo

; Marcello Pogliani <marcello.pogliani AT mail.polimi.it>

(define (count-nodes l)
  (cond
    ([null? l] 0)
    ([list? (car l)]
          (+ (count-nodes (car l)) (count-nodes (cdr l))))
    (else (+ 1 (count-nodes (cdr l))))))

; Valori di test

(count-nodes '('1 '2 '3)) ; ==> 6
(count-nodes '(1 2 3 (+ 4 5))) ; ==> 6
(count-nodes '(1 2 (+ 3 (- 2 3) (* 4 5 (prova prova prova))) 4)) ; ==> 14
(count-nodes '((+ 1 2 3 4 5) '2 '3)) ; ==> 10
(count-nodes '((+ 1 2 3 4 5) (+ 2 3 4) ((+ 1 2) 3))) ; ==> 14
