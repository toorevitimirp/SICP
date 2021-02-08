; #lang sicp

; (define (delay exp)
;   (lambda () exp))

; (define (force delayed-object)
;   (delayed-object))

; (define (cons-stream a b)
;   (cons a (delay b)))

; (define (stream-car stream) 
;   (car stream))

; (define (stream-cdr stream) 
;   (force (cdr stream)))

; (define (stream-enumerate-interval low high)
;   (if (> low high)
;       the-empty-stream
;       (cons-stream
;        low
;        (stream-enumerate-interval (+ low 1)
;                                   high))))

; (stream-cdr (stream-enumerate-interval 0 9))
; ; (stream-cdr (cons 0 (delay (stream-enumerate-interval 1 9))))
; ; (force (cdr (cons 0 (delay (stream-enumerate-interval 1 9)))))
; ; (force (delay (stream-enumerate-interval 1 9)))
; ; (force (delay (cons 1 (delay  (stream-enumerate-interval 2 9)))))
; ;Eager evaluation
; ; (force (delay (1 . (delay  (stream-enumerate-interval 2 9)))))
(load "stream.scm")

; (define (integers-starting-from n)
;   (cons-stream 
;    n (integers-starting-from (+ n 1))))
; (define integers (integers-starting-from 1))
(define ones (cons-stream 1 ones))
(define twos (add-streams ones ones))

(define integers (cons-stream 1 (add-streams ones integers)))

(cons-stream 1 (add-streams ones integers))

