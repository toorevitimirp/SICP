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
 