#lang racket

; Count nodes ricorsivo

; Non considera le liste come alberi il cui primo elemento è la radice, ma come liste annidate "semplicemente"
; ad esempio (count-nodes ((+ 1 2) 3 4)) => 5 e non 3

(define (count-nodes l)
  (cond
    ([null? l] 0)
    ([list? (car l)]
          (+ (count-nodes (car l)) (count-nodes (cdr l))))
    (else (+ 1 (count-nodes (cdr l))))))

; Altro modo

(define (count-nodes-v2 l)
  (cond
    ([null? l] 0)
    ([list? l] (apply + (map count-nodes-v2 l)))
    (else 1)))

; qui considera le liste come alberi (come nel testo dell'esercizio corretto)

(define (count-nodes-tree l)
  (cond 
     ([null? l] 0)
     ([list? l] (foldl + 1 (map count-nodes-tree (cdr l))))
     (else 1)))

; Valori di test

(count-nodes '('1 '2 '3)) ; ==> 6
(count-nodes '(1 2 3 (+ 4 5))) ; ==> 6
(count-nodes '(1 2 (+ 3 ((+ 2 3 4 5) 2 3) (* 4 5 (prova prova prova))) 4)) ; ==> 18
(count-nodes '((+ 1 2 3 4 5) '2 '3)) ; ==> 10
(count-nodes '((+ 1 2 3 4 5) (+ 2 3 4) ((+ 1 2) 3))) ; ==> 14
