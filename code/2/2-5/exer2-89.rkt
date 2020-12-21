#lang sicp

(#%require "type.rkt")
(#%require "table.rkt")
(#%require "generic.rkt")

(#%require "install-polynomial-package.rkt")

(define (first-term term-list)
  (make-term (- (length term-list) 1)
             (car term-list)))

(define (adjoin-term term term-list)
  (let ((ord (order term))
        (coe (coeff term))
        (first (first-term term-list)))
    (cond ((empty-termlist? term-list)
           '())
          ((> ord (order first))
           (cons coe term-list))
          ((= ord (order first))
           (cons (+ coe (coeff first)) term-list))
          (else
           (cons first (adjoin-term term (rest-terms term-list)))))))

  ; (define (negative-termlist L)
  ;   (if (empty-termlist? L)
  ;       (the-empty-termlist)
  ;       (adjoin-term
  ;        (make-term (order (first-term L))
  ;                   (negative (coeff (first-term L))))
  ;        (negative-termlist (rest-terms L)))))