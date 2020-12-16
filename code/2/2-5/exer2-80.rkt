#lang sicp

(#%require "type.rkt")
(#%require "table.rkt")
(#%require "install-complex-package.rkt")
(#%require "install-number-package.rkt")
(#%require "install-rational-package.rkt")

(define (install-=zero?-package)
  (define numer (get 'numer '(rational)))
  (define magnitude (get 'my-magnitude '(complex)))
  
  (define =zero?-number (lambda (x)
   (= x 0)))
  (define =zero?-rational (lambda (x)
     (= (*(numer x) 0))))
  (define =zero?-complex (lambda (x y)
    (= (magnitude x) 0)))
                                                        
  (put '=zero? '(scheme-number scheme-number) =zero?-number)
  (put '=zero? '(rational rational) =zero?-rational)
  (put '=zero? '(complex complex) =zero?-complex)
  'done)

(install-=zero?-package)

(define (=zero? x y)
  (apply-generic '=zero? x y))

;;;test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
