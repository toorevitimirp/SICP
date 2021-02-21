#lang sicp

; (define new-withdraw
;   (let ((balance 100))
;     (lambda (amount)
;       (if (>= balance amount)
;           (begin (set! balance 
;                        (- balance amount))
;                  balance)
;           "Insufficient funds"))))

; (new-withdraw 50)
; (new-withdraw 50)

(define (make-simplified-withdraw balance)
  (lambda (amount)
    (set! balance (- balance amount))
    balance))

((make-simplified-withdraw 25) 20)
