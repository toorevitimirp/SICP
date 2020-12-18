#lang sicp

(#%require "type.rkt")
(#%require "table.rkt")
(#%require "generic.rkt")

;;;(#%provide make-real)

(define (install-real-package)
  (define (tag x)
    (attach-tag 'real x))
  (put 'add '(real real)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(real real)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(real real)
       (lambda (x y) (tag (* x y))))
  (put 'div '(real real)
       (lambda (x y) (tag (/ x y))))
  (put 'addd '(real real real)
       (lambda (x y z) (tag (+ x y z))))
  (put 'equ? '(real real)
       (lambda (x y)
         (= x y)))
  (put '=zero? '(real)
       (lambda (x)
         (= x 0.0)))
  (put 'negative '(real)
       (lambda (x)
         (tag(- x))))
  (put 'raise '(real)
     (lambda (x) (make-complex-from-real-imag x 0)))
  (put 'project '(real)
     (lambda (r) (make-rational
                  (round r)
                  1)))
  (put 'make 'real
       (lambda (x) (tag x)))
  'done)

(define (make-real n)
  ((get 'make 'real) n))

(install-real-package)