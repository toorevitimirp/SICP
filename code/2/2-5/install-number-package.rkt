#lang sicp

;;;(#%provide make-scheme-number)

(#%require "type.rkt")
(#%require "table.rkt")
(#%require "generic.rkt")

(define (install-scheme-number-package)
  (define (tag x)
    (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'raise '(scheme-number)
     (lambda (x) (make-rational x 1)))
  (put 'addd '(integer integer integer)
       (lambda (x y z) (tag (+ x y z))))
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y)
         (= x y)))
  (put 'make 'scheme-number
       (lambda (x) (tag x)))
  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(install-scheme-number-package)