;;;continuation 和 call/cc 的基本概念：
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


;;;一些例子
;;1.
(let ([x (call/cc (lambda (k) k))])
  (x (lambda (ignore) "hi")))

((lambda (x)
   (x (lambda (ignore) "hi")))
 (call/cc (lambda (k) k)))

;what is k?
(lambda (v)
  ((lambda (x)
     (x (lambda (ignore) "hi")))
   v))

(lambda (v)
  (let ((x v))
    (x (lambda (ignore "hi")))))

((lambda (x)
   (x (lambda (ignore) "hi")))
 (lambda (v)
   ((lambda (x)
      (x (lambda (ignore) "hi")))
    v)))

((lambda (v)
   ((lambda (x)
      (x (lambda (ignore) "hi")))
    v))
 (lambda (ignore) "hi"))

((lambda (x)
   (x (lambda (ignore) "hi")))
 (lambda (ignore) "hi"))

((lambda (ignore) "hi")
 (lambda (ignore) "hi"))

((lambda (ignore) "hi")
 (lambda (ignore) "hi"))

;;2.
(((call/cc (lambda (k) k))
  (lambda (x) x))
 "hey!")

;what is k?
(lambda (v)
  (v (lambda (x) x)))

(((lambda (v)
    (v (lambda (x) x)))
  (lambda (x) x))
 "hey!")

(((lambda (x) x)
  (lambda (x) x))"hey!")

((lambda (x) x)"hey!")

;;3.
(define product
  (lambda (ls)
    (call/cc
      (lambda (break)
        (let f ([ls ls])
          (cond
            [(null? ls) 1]
            [(= (car ls) 0) (break 0)]
            [else (* (car ls) (f (cdr ls)))]))))))

(define product
  (lambda (ls)
    (let f ([ls ls])
      (cond
        [(null? ls) 1]
        [(= (car ls) 0) 0]
        [else (* (car ls) (f (cdr ls)))]))))
;what is break?
(lambda (v)
  v)

(define product
  (lambda (ls)
    ((lambda (break)
        (let f ([ls ls])
          (cond
            [(null? ls) 1]
            [(= (car ls) 0) (break 0)]
            [else (* (car ls) (f (cdr ls)))])))
     (lambda (v) v))))

(define product
  (lambda (ls)
    (let f ([ls ls])
      (cond
        [(null? ls) 1]
        [(= (car ls) 0) ((lambda (v) v) 0)]
        [else (* (car ls) (f (cdr ls)))]))))

;what the difference?
(define product
  (lambda (ls)
    (let f ([ls ls])
      (cond
        [(null? ls) 1]
        [(= (car ls) 0) 0]
        [else (* (car ls) (f (cdr ls)))]))))


;;;cps
(define fact-cps
  (lambda (n k)
    (cond
      [(zero? n) (k 1)]
      [else (fact-cps (sub1 n)
                      (lambda (v)
                        (k (* v n))))])))
;think of v as (fact n)

(define fact
  (lambda (n)
    (fact-cps n (lambda (v) v))))