#lang sicp

(#%require "type.rkt")
(#%require "table.rkt")

(define (level type) 
  (get 'level type)) 

(define (install-level-package) 
   (put 'level 'scheme-number 1) 
   (put 'level 'rational 2) 
   (put 'level 'real 3) 
   (put 'level 'complex 4) 
   'done) 
  
(install-level-package) 

(define (find-highest-type types)
  (cond ((null? types) false)
        ;  (error "empty type list"))
        ((=(length types) 1) (car types))
        (else
         (let ((current (car types))
               (remain (find-highest-type (cdr types))))
           (if (> (level current) (level remain))
               current
               remain)))))

(define (raise-one highest arg)
  (if (equal? (type-tag arg) highest)
      arg
      (if (raise arg)
          (raise-one highest (raise arg))
          (error "no raise method for this type" arg))))

(define (raise-all args)
   (if (null? args)
       '()
       (let ((highest (find-highest-type (map type-tag args))))
         (cons (raise-one highest (car args)) (raise-all (cdr args))))))
          
(define (apply-generic-2-84 op . args)
     (let ((proc (get op (map type-tag args))))
       (if proc
           (apply proc (map contents args))
           (let ((new-args (raise-all args)))
              (let ((proc (get op (map type-tag new-args))))
                 (apply proc (map contents args)))))))

;;;test
(#%require "install-complex-package.rkt")
(#%require "install-number-package.rkt")
(#%require "install-real-package.rkt")
(#%require "install-rational-package.rkt")


(put 'raise '(scheme-number)
     (lambda (x) (make-rational x 1)))
(put 'raise '(rational)
     (lambda (x) (make-real (/ ((get 'numer '(rational)) x)
                               ((get 'denom '(rational)) x)))))
(put 'raise '(real)
     (lambda (x) (make-complex-from-real-imag x 0)))

(define (raise x)
  (let ((proc (get 'raise (list (type-tag x)))))
    (if proc
        (apply-generic-2-84 'raise x)
        false)))

(define a1 (make-scheme-number 42))
(define a2 (make-rational 3 4))
(define a3 (make-real 2.14))
(define a4 (make-complex-from-real-imag 2 5))

(define test-list (list a1 a2 a3 a4))

(raise-all test-list)