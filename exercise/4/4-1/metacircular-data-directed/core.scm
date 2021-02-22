(load "derived-exp.scm")

(define (eval_ exp env)
  (cond ((self-evaluating? exp) 
         exp)
        ((variable? exp) 
         (lookup-variable-value exp env))
        (else (let ((eval-dispatch
                     (get 'eval-dispatch (type-exp exp))))
                (if eval-dispatch
                    (begin
                      ; (display "basic or derived expression\n")
                      (eval-dispatch exp env))
                    (if (application? exp)
                        (apply_ (eval_ (operator exp) env)
                               (list-of-values 
                                (operands exp) 
                                env))
                        (error "Unknown expression 
                               type: EVAL" exp)))))))

(define (apply_ procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure 
          procedure 
          arguments))
        ((compound-procedure? procedure)
         ((get 'eval-sequence 'begin)
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
