#lang racket

(require
 "exceptions_marcello.scm")

;; Extended throw\catch
;; Usage example
;; Marcello Pogliani <marcello.pogliani@gmail.com>, 2012/04/04

; Defining some throwing functions
(define (foo x)
  (display x)
  (newline)
  (throw exception "Foo throwing!")
  (display "This should be unreachable"))

(define (bar x)
  (display x)
  (newline)
  (throw bar "Bar throwing!")
  (display "This should be unreachable"))

; Skip a catch block...
(begin
(catch exception e (begin
                     (display "Primo catch\n")
                     (display e)
                     (newline)
                     #f)
  (catch bar e (begin
                 (display "Secondo catch\n")
                 (display e)
                 (display "\nFine del catch\n")
                 (newline)
                 #f)
    (catch baz e (begin
                   (display "Why am I here???")
                   #f)
      (bar "Ciao!")
      (display "After the throw\n"))))
(display "After all...\n"))

; Catch all
(catch-all e (begin
               (display "Catch all\n")
               #f)
           (foo "ciao")
           (bar "prova")
           )

;; No suitable handler set up => error
(catch noone e (begin
                 (display "Not to be executed\n")
                 #f)
  (foo "Hi"))
