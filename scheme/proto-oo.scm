#lang racket

;; Proto-OO Prototype Object System
;; Copied down from Matteo Pradella's lecture notes
;; Politecnico di Milano -- Principi dei Linguaggi 2013
;; Wrt the slides, inheritance and traits already added

(provide
 new-object
 clone
 son-of
 dispatch
 extend
 internals
 !!
 ??
 ->)

;; An object is implemented with an hash table where keys are symbols
;; Keys are attribute \ method names

(define new-object make-hasheq)

(define (clone object)
  (hash-copy object))

(define-syntax !! ;; Setter
  (syntax-rules ()
    ((_ object msg new-val)
     (hash-set! object 'msg new-val))))

(define-syntax ?? ;; Getter
  (syntax-rules ()
    ((_ object msg)
     (dispatch object 'msg))))

(define-syntax -> ;; Send message
  (syntax-rules ()
    ((_ object msg arg ...)
     ((dispatch object 'msg) object arg ...))))

;; Inheritance by delegation
(define (son-of parent)
  (let ((o new-object))
    (!! o <<parent>> parent)
    o))

;; Dispatching
(define (dispatch object msg)
  (if (eq? object 'unknown)
      (error "Unknown message" msg)
      (let ((slot (hash-ref object msg 'unknown)))
        (if (eq? slot 'unknown)
            (dispatch (hash-ref object '<<parent>> 'unknown) msg)
            slot))))

;; Mixins\traits
;; A trait is a container of data\methods which can be combined
;; to add behavior to objects

(define (extend target trait)
  (hash-for-each trait ;; loop on table "trait"
                 (lambda (key val)
                   (hash-set! target key val))))

(define internals hash-keys)

;; Some examples

(define Glenn (new-object))
(!! Glenn name "Glenn")

(define Pianist (new-object)) ;; a trait
(!! Pianist piano "Steinway CD318")
(!! Pianist play (lambda (self)
                   (display (?? self name))
                   (display " is playing his ")
                   (display (?? self piano))
                   (newline)))

(extend Glenn Pianist)
(-> Glenn play) ;; Glenn is playing his Steinway CD318