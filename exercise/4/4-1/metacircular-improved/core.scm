(load "derived-exp.scm")

; (define (eval_ exp env)
;   (cond ((self-evaluating? exp) 
;          exp)
;         ((variable? exp) 
;          (lookup-variable-value exp env))
;         (else (let ((eval-dispatch
;                      (get 'eval-dispatch (type-exp exp))))
;                 (if eval-dispatch
;                     (eval-dispatch exp env)
;                     (if (application? exp)
;                         (apply_ (eval_ (operator exp) env)
;                                (list-of-values 
;                                 (operands exp) 
;                                 env))
;                         (error "Unknown expression 
;                                type: EVAL" exp)))))))

(define (eval_ exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) 
         (lookup-variable-value exp env))
        ((get 'eval-dispatch (type-exp exp))
         ((get 'eval-dispatch (type-exp exp)) exp env))
        ((application? exp)
         (apply_ (eval_ (operator exp) env)
                 (list-of-values (operands exp) env)))
        ;;;这行似乎永远不会被运行
        (else (error "Unknown expression type: EVAL" exp))))

(define (apply_ procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure 
          procedure 
          arguments))
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
             (procedure-parameters 
              procedure)
             arguments
           (procedure-environment 
            procedure))))
        (else
         (error "Unknown procedure 
                 type: APPLY" 
                 procedure))))
