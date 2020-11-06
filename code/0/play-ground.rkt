#lang sicp

(define (square a)
  (* a a))

(define x 2)

;;; ((lambda (x y)
;;;   (* x y))
;;;   3 (+ x 2))

((lambda (x) (+ x (* x 10))) 3)