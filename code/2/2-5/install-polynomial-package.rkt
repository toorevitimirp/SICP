#lang sicp


(#%require "type.rkt")
(#%require "table.rkt")
(#%require "variable.rkt")
(#%require "generic.rkt")


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

  ;;representation of terms
(define (make-term order coeff) 
  (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))


(define (install-dense-package)
  (define (adjoin-term term term-list)
    (let ((ord (order term))
          (coe (coeff term))
          (first (first-term term-list)))
      (cond ((empty-termlist? term-list)
             '())
            ((> ord (order first))
             (cons coe term-list))
            ((= ord (order first))
             (cons (+ coe (coeff first)) term-list))
            (else
             (cons (coeff first) (adjoin-term term (rest-terms term-list)))))))
  (define (the-empty-termlist) '())
  (define (first-term term-list)
    (make-term (- (length term-list) 1)
               (car term-list)))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) 
    (null? term-list))
  (define (negative-termlist L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (adjoin-term
         (make-term (order (first-term L))
                    (negative (coeff (first-term L))))
         (negative-termlist (rest-terms L)))))
  (define (make-termlist coeffs)
    coeffs)
  
  (define (tag p) (attach-tag 'dense p))
  (put 'adjoin-term 'dense
       (lambda (term termlist) (tag (adjoin-term term termlist))))
  (put 'negative-termlist '(dense)
       (lambda (termlist)
         (tag (negative-termlist termlist))))
  (put 'the-empty-termlist '(dense) the-empty-termlist)
  (put 'first-term '(dense) first-term)
  (put 'rest-terms '(dense)
       (lambda (term-list)
         (tag (rest-terms term-list))))
  (put 'empty-termlist? '(dense) empty-termlist?)
  (put 'make-termlist 'dense
       (lambda (coeffs)
         (tag (make-termlist coeffs))))
  'done)


(define (install-sparse-package)
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
        term-list
        (cons term term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (negative-termlist L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (adjoin-term
         (make-term (order (first-term L))
                    (negative (coeff (first-term L))))
         (negative-termlist (rest-terms L)))))
  (define (empty-termlist? term-list) 
    (null? term-list))
  (define (make-termlist terms)
    terms)

  (define (tag p) (attach-tag 'sparse p))
  (put 'adjoin-term 'sparse
       (lambda (term termlist) (tag (adjoin-term term termlist))))
  (put 'the-empty-termlist 'sparse the-empty-termlist)
    (put 'negative-termlist '(sparse)
       (lambda (termlist)
         (tag (negative-termlist termlist))))
  (put 'first-term '(sparse) first-term)
  (put 'rest-terms '(sparse)
       (lambda (term-list)
         (tag (rest-terms term-list))))
  (put 'empty-termlist? '(sparse) empty-termlist?)
  (put 'make-termlist 'sparse
       (lambda (terms)
         (tag (make-termlist terms))))
  'done)


(install-dense-package)
(install-sparse-package)

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
(define (negative-termlist term-list)
  (apply-generic 'negative-termlist term-list))

(define (make-dense-termlist coeffs)
  ((get 'make-termlist 'dense) coeffs))
(define (make-sparse-termlist terms)
  ((get 'make-termlist 'sparse) terms))


(define (install-polynomial-package)
  ;; internal procedures
  
  ;; representation of poly
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  
  ;; representation of terms and term lists
  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
           (let ((t1 (first-term L1)) 
                 (t2 (first-term L2)))
             (cond ((> (order t1) (order t2))
                    (adjoin-term
                     t1 
                     (add-terms (rest-terms L1) 
                                L2)))
                   ((< (order t1) (order t2))
                    (adjoin-term
                     t2 
                     (add-terms 
                                L1 
                                (rest-terms L2))))
                   (else
                    (adjoin-term
                     (make-term 
                    (order t1)
                    (add (coeff t1) 
                         (coeff t2)))
                     (add-terms 
                                (rest-terms L1)
                                (rest-terms L2)))))))))
  (define (sub-terms L1 L2)
    (cond ((empty-termlist? L1)
           (negative-termlist L2))
          ((empty-termlist? L2)
           L1)
          (else (let ((t1 (first-term L1))
                      (t2 (first-term L2)))
                  (cond ((> (order t1) (order t2))
                         (adjoin-term
                          t1
                          (sub-terms (rest-terms L1) L2)))
                        ((< (order t1) (order t2))
                         (adjoin-term
                          (make-term (order t2)
                                     (negative (coeff t2)))
                          (sub-terms L1 (rest-terms L2))))
                        (else (adjoin-term
                               (make-term (order t1)
                                          (sub (coeff t1) (coeff t2)))
                               (sub-terms (rest-terms L1) (rest-terms L2)))))))))
  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
        (the-empty-termlist)
        (add-terms 
                   (mul-term-by-all-terms 
                    (first-term L1) L2)
       (mul-terms (rest-terms L1) L2))))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (let ((t2 (first-term L)))
          (adjoin-term
         (make-term 
        (+ (order t1) (order t2))
        (mul (coeff t1) (coeff t2)))
         (mul-term-by-all-terms 
          t1 
          (rest-terms L))))))
  
  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) 
                        (variable p2))
        (make-poly 
         (variable p1)
         (add-terms (term-list p1)
                    (term-list p2)))
        (error "Polys not in same var: 
               ADD-POLY"
               (list p1 p2))))
  (define (sub-poly p1 p2)
    (if (same-variable? (variable p1) 
                        (variable p2))
        (make-poly 
         (variable p1)
         (sub-terms (term-list p1)
                    (term-list p2)))
        (error "Polys not in same var: 
               SUB-POLY"
               (list p1 p2))))
  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) 
                        (variable p2))
      (make-poly 
       (variable p1)
       (mul-terms (term-list p1)
                  (term-list p2)))
      (error "Polys not in same var: 
             MUL-POLY"
             (list p1 p2))))
  (define (=zero-all-terms? L)
    (cond ((empty-termlist? L) #t)
          ((not (=zero? (coeff (first-term L)))) #f)
          (else (=zero-all-terms? (rest-terms L)))))
                      
  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) 
         (tag (add-poly p1 p2))))
  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2)
         (tag (sub-poly p1 p2))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) 
         (tag (mul-poly p1 p2))))
  (put 'negative '(polynomial)
       (lambda (p)
         (tag (make-poly
               (variable p)
               (negative-termlist (term-list p))))))
  (put '=zero? '(polynomial)
    (lambda (p)
      (=zero-all-terms? (term-list p))))
  (put 'make 'polynomial
       (lambda (var terms) 
         (tag (make-poly var terms))))
  'done)

(install-polynomial-package)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))
