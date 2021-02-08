(load "stream.scm")

(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1)
                  (stream-car s2))
               (add-streams
                (scale-stream (stream-cdr s2)
                              (stream-car s1))
                (mul-series (stream-cdr s1) s2))))

(define (1/s s)
  (define x
    (cons-stream 1
                 (mul-series (scale-stream (stream-cdr s) -1)
                             x)))
  x)

(define (div-series s1 s2)
  (let ((c (stream-car s2)))
    (if (= c 0)
        (error "stream divided by zero: "
               "DIV-SERIES")
        (mul-series (scale-stream s1 (/ 1 c))
                    (1/s  (scale-stream s2 (/ 1 c)))))))

;;;test1
(define exp-series
  (cons-stream 
   1 (integrate-series exp-series)))

(define cosine-series 
  (cons-stream 1 (integrate-series (scale-stream sine-series -1))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

(define tan-series (div-series sine-series cosine-series))

; (dsn tan-series 20)

;;;test2
(define (power-stream v)
  (define ps (cons-stream 1 (scale-stream ps v)))
  ps)

(define (calcu-series series x)
  (let ((n 100))
    (exact->inexact(stream-accumulate +
                       0
                       (mul-streams
                        (power-stream x)
                        series)
                       n))))

(define pi (* 4 (atan 1.0)))

(define (my-sin x)
  (calcu-series sine-series x))

(define (my-cos x)
  (calcu-series cosine-series x))

(define (my-tan x) ; x< pi/2才收敛
  (define (x->converge-circle x)
    (cond ((> x (/ pi 2))
           (x->converge-circle (- x pi)))
          ((< x (/ pi -2))
           (x->converge-circle (+ x pi)))
          (else x)))
  (calcu-series tan-series (x->converge-circle x)))

(define (my-exp x)
  (calcu-series exp-series x))

