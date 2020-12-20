#lang sicp
;;;为什么要将通用操作集中到一个文件中,而不是将它们分散到各个包中?
;;;为了避免环型依赖。例如real包的raise函数需要依赖complex包，而complex包的drop函数依赖real包。
;;;我想不出其它的好办法。
(#%provide apply-generic raise
            project drop equ?
            make-scheme-number
            make-rational
            make-complex-from-real-imag
            make-complex-from-mag-ang
            make-real
            my-angle
            my-magnitude
            my-imag-part
            my-real-part
            add sub div mul
            =zero? negative)

(#%provide make-term
           order
           coeff
           the-empty-termlist
           first-term
           rest-terms
           adjoin-term
           empty-termlist?
           make-dense-termlist
           make-sparse-termlist
           make-polynomial)

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

(define (apply-generic op . args)
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
            (error "no raising method for this type : RASIE-ONE"  arg))))
  (define (raise-all highest args)
    (if (null? args)
       '()
       (cons (raise-one highest (car args)) (raise-all highest (cdr args)))))
  (let ((proc (get op (map type-tag args))))
    (if proc
       (apply proc (map contents args))
       (let ((highest (find-highest-type (map type-tag args))))
         (let ((new-args (raise-all highest args)))
           (let ((proc (get op (map type-tag new-args))))
             (drop (apply proc (map contents new-args)))))))))

(define (raise x)
  (let ((proc (get 'raise (list (type-tag x)))))
    (if proc
        (apply-generic 'raise x)
        false)))

(define (project x)
  (let ((proc (get 'project (list (type-tag x)))))
    (if proc
        (apply-generic 'project x)
        false)))

(define (drop x)
  (define (dropable? x)
    (and (project x)
         (equ? (raise (project x)) x)))
  (if (dropable? x)
      (drop (project x))
      x))

(define (equ? x y)
  (apply-generic 'equ? x y))

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(define (make-rational n d)
  ((get 'make 'rational) n d))

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

(define (my-real-part z) (apply-generic 'my-real-part z)) 
(define (my-imag-part z) (apply-generic 'my-imag-part z)) 
(define (my-magnitude z) (apply-generic 'my-magnitude z)) 
(define (my-angle z) (apply-generic 'my-angle z))

(define (make-real n)
  ((get 'make 'real) n))

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))

(define (=zero? x)
  (apply-generic '=zero? x))

(define (add a1 a2)
  (apply-generic 'add a1 a2))

(define (sub a1 a2)
  (apply-generic 'sub a1 a2))

(define (mul a1 a2)
  (apply-generic 'mul a1 a2))

(define (div a1 a2)
  (apply-generic 'div a1 a2))

(define (negative a)
  (apply-generic 'negative a))

(define (adjoin-term term term-list)  
  ((get 'adjoin-term (type-tag term-list))
   term (contents term-list)))
(define (first-term term-list)
  (apply-generic 'first-term term-list)) 
(define (rest-terms term-list)
  (apply-generic 'rest-terms term-list))
(define (empty-termlist? termlist)
  (apply-generic 'empty-termlist? termlist))
(define (the-empty-termlist)
   ((get 'the-empty-termlist 'sparse)))

(define (make-dense-termlist coeffs)
  ((get 'make-termlist 'dense) coeffs))
(define (make-sparse-termlist terms)
  ((get 'make-termlist 'sparse) terms))

(define (make-term order coeff) 
  (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))