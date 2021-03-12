;;;continuation和call/cc的基本概念：
;;;exp (+ (* 3 4) 5)
(define *k* #f)

(+ (* 3 4) 5)
; (lambda (v) v)
(call/cc (lambda (k)
           (k (+ (* 3 4) 5))))

(* 3 4)
; (lambda (v) (+ v 5))
(+ (call/cc (lambda (k)
              (k (* 3 4))))
   5)

3
; (lambda (v) (+ (* v 4) 5))
(+ (* (call/cc (lambda (k)
                 (set! *k* k)
                 (k 3)))
      4)
   5)

4
; (lambda (v) (+ (* 3 v) 5))
(+ (* 3
      (call/cc (lambda (k)
                 (k 4))))
   5)

5
;(lambda (v) (+ (* 3 4) v))
(+ (* 3 4)
   (call/cc (lambda (k)
              (k 5))))

*k*
(define x (*k* 5))
