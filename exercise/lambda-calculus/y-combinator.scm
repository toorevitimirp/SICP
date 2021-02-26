;;;loop:
;;;((lambda (x) (x x))
;;;  (lambda (x) (x x)))

(define Y
  (lambda (f)
    ((lambda (x) (f (x x)))
     (lambda (x) (f (x x))))))

; ;(Y F)
; ((lambda (x) (F (x x)))
;  (lambda (x) (F (x x))))

; (F
;  ((lambda (x) (F (x x)))
;   (lambda (x) (F (x x)))))

;;;上面的Y会造成死循环，下面的不会。
(define Y
  (lambda (f)
    ((lambda (x) (x x))
     (lambda (x) (f (lambda (y) ((x x) y)))))))