#lang sicp
(define (even? a)
    (= (remainder a 2) 0))

(define (double a)
  (+ a a))

(define (half a)
  (define (iter res)
    (if (= (double res) a)
        res
        (iter (+ res 1))))
  (if (even? a) (iter 1)
      (error "invalid integer")))

(define (* a b)
  (define (iter a b addtion)
    (cond ((= b 1) (+ a addtion))
          ((even? b)  (iter (double a) (half b) addtion))
          (else (iter a (- b 1) (+ addtion a)))))
  (iter a b 0))
(* 3 21)