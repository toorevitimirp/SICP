#lang sicp

(#%require "constraint.rkt")
(#%require "connector.rkt")

(define (reciprocal a b)
   (define (process-new-value)
      (if (has-value? b)
          (if (= (get-value b) 0)
              (error "reciprocal equals 0: 
                      RECIPROCAL" 
                      (get-value b))
            (set-value! a (/ 1 (get-value b)) me))
          (if (has-value? a)
              (if (= (get-value a) 0)
              (error "reciprocal equals 0: 
                      RECIPROCAL" 
                      (get-value a))
              (set-value! b (/ 1 (get-value a)) me)))))
   (define (process-forget-value)
      (forget-value! b me)
      (forget-value! a me)
      (process-new-value))
   (define (me request)
      (cond ((eq? request 'I-have-a-value)
             (process-new-value))
            ((eq? request 'I-lost-my-value)
             (process-forget-value))
            (else
             (error "Unknown request: 
                     SQUARER" 
                     request))))
   (connect a me)
   (connect b me)
   me)

(define (c+ x y)
  (let ((z (make-connector)))
    (adder x y z)
    z))

(define (c* x y)
   (let ((z (make-connector)))
     (multiplier x y z)
     z))

(define (c/ x y)
   (let ((z (make-connector))
         (1/y (make-connector)))
     (reciprocal y 1/y)
     (multiplier x 1/y z)
     z))

(define (cv v)
   (let ((z (make-connector)))
     (constant v z)
     z))

(define (celsius-fahrenheit-converter x)
  (c+ (c* (c/ (cv 9) (cv 5))
          x)
      (cv 32)))

(define C (make-connector))
(define F (celsius-fahrenheit-converter C))

(probe "Celsius temp" C)
(probe "Fahrenheit temp" F)

(set-value! C 25 'user)

(forget-value! C 'user)

(set-value! F 212 'user)