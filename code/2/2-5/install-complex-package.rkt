#lang sicp

(#%require "type.rkt")
(#%require "table.rkt")
(#%require "generic.rkt")

;;;(#%provide make-complex-from-real-imag
;;;           make-complex-from-mag-ang)

(define (square x) (* x x))
(define (real-part z) (apply-generic 'real-part z)) 
(define (imag-part z) (apply-generic 'imag-part z)) 
(define (my-magnitude z) (apply-generic 'my-magnitude z)) 
(define (angle z) (apply-generic 'angle z))

(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) 
    (cons x y))
  (define (my-magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))
  ;; interface to the rest of the system
  (define (tag x) 
    (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'my-magnitude '(rectangular) my-magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) 
         (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) 
         (tag (make-from-mag-ang r a))))
  'done)

;;;极坐标
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (install-polar-package)
  ;; internal procedures
  (define (my-magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (my-magnitude z) (cos (angle z))))
  (define (imag-part z)
    (* (my-magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y)
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))
  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'my-magnitude '(polar) my-magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) 
         (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) 
         (tag (make-from-mag-ang r a))))
  'done)

(install-polar-package)
(install-rectangular-package)

;;;generic interface
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (install-complex-package)
  ;; imported procedures from rectangular 
  ;; and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 
          'rectangular) 
     x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) 
     r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag 
     (+ (real-part z1) (real-part z2))
     (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag 
     (- (real-part z1) (real-part z2))
     (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang 
     (* (my-magnitude z1) (my-magnitude z2))
     (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang 
     (/ (my-magnitude z1) (my-magnitude z2))
     (- (angle z1) (angle z2))))
  (define (addd-complex z1 z2 z3)
    (make-from-real-imag (+ (real-part z1)
                            (real-part z2)
                            (real-part z3))
                         (+ (imag-part z1)
                            (imag-part z2)
                            (imag-part z3))))
  ;; interface to rest of the system
  (put 'addd '(complex complex complex)
       (lambda (z1 z2 z3) (tag (addd-complex z1 z2 z3))))
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) 
         (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) 
         (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) 
         (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) 
         (tag (div-complex z1 z2))))
  (put 'equ? '(complex complex)
       (lambda (x y)
         (and (= (real-part x)
                 (real-part y))
              (= (imag-part x)
                 (imag-part y)))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) 
         (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) 
         (tag (make-from-mag-ang r a))))
  (put 'project '(complex)
       (lambda (c) (make-real
                    ((get 'real-part '(complex)) c))))
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'my-magnitude '(complex) my-magnitude)
  (put 'angle '(complex) angle)
  'done)

(install-complex-package)
(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))