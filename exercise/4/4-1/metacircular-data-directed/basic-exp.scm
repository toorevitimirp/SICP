(load "utils.scm")
(load "env.scm")

(define apply-in-underlying-scheme apply)

;;;number & string
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        ((eq? exp '#t) true)
        ((eq? exp '#f) true)
        (else false)))

;;;variable
; (variable? 'true) => true
; (variable? 'false) => true
; (variable? '#t) => false
; (variable? '#t) => false
(define (variable? exp) (symbol? exp))

;;;quotation
(define (install-quotation)
  (define keyword 'quote)
  (define (text-of-quotation exp env)
    (cadr exp))
  (put 'eval-dispatch keyword text-of-quotation)
  "installed quotation")
(install-quotation)

;;;assignment
(define (install-assignment)
  (define keyword 'set!)
  (define (assignment-variable exp) 
    (cadr exp))
  (define (assignment-value exp) (caddr exp))
  (define (eval-assignment exp env)
    (set-variable-value! 
     (assignment-variable exp)
     (eval (assignment-value exp) env)
     env)
    "<#assignment return#>")
  (put 'eval-dispatch keyword eval-assignment)
  "installed assignment")
(install-assignment)

;;;definition
(define (install-definition)
  (define keyword 'define)
  (define (definition-variable exp)
    (if (symbol? (cadr exp))
        (cadr exp)
        (caadr exp)))
  (define (definition-value exp)
    (if (symbol? (cadr exp))
        (caddr exp)
        ((get 'make-lambda 'lambda) 
          (cdadr exp)   ; formal parameters
          (cddr exp)))) ; body
  (define (eval-definition exp env)
    (define-variable! 
      (definition-variable exp)
      (eval (definition-value exp) env)
      env)
    "<#definition return#>")
  (put 'eval-dispatch keyword eval-definition)
  "installed definition")
(install-definition)

;;;lambda
(define (install-lambda)
  (define keyword 'lambda)
  (define (lambda-parameters exp) (cadr exp))
  (define (lambda-body exp) (cddr exp))
  (define (eval-lambda exp env)
    (make-procedure 
     (lambda-parameters exp)
     (lambda-body exp)
     env))
  (define (make-lambda parameters body)
    (cons 'lambda (cons parameters body)))
  (put 'make-lambda keyword make-lambda)
  (put 'eval-dispatch keyword eval-lambda)
  "installed lambda")
 (install-lambda)

;;;if
(define (installed-if)
  (define keyword 'if)
  (define (if-predicate exp) (cadr exp))
  (define (if-consequent exp) (caddr exp))
  (define (if-alternative exp)
    (if (not (null? (cdddr exp)))
        (cadddr exp)
      'false))
  (define (make-if predicate 
                   consequent 
                   alternative)
    (list 'if 
          predicate 
          consequent 
          alternative))
  (define (eval-if exp env)
    (if (true? (eval (if-predicate exp) env))
        (eval (if-consequent exp) env)
        (eval (if-alternative exp) env)))
  (put 'make-if keyword make-if)
  (put 'eval-dispatch keyword eval-if)
  "install if")
(installed-if)

;;;begin & sequence
(define (install-sequence)
  (define keyword 'begin)
  (define (begin-actions exp) (cdr exp))
  (define (last-exp? seq) (null? (cdr seq)))
  (define (first-exp seq) (car seq))
  (define (rest-exps seq) (cdr seq))
  (define (sequence->exp seq)
    (cond ((null? seq) seq)
          ((last-exp? seq) (first-exp seq))
          (else (make-begin seq))))
  (define (make-begin seq) (cons 'begin seq))
  (define (eval-sequence exps env)
    (cond ((last-exp? exps)
           (eval (first-exp exps) env))
          (else 
           (eval (first-exp exps) env)
           (eval-sequence (rest-exps exps) 
                          env))))
  (define (eval-begin exp env)
    (eval-sequence (begin-actions exp) env))
  (put 'make-begin keyword make-begin)
  (put 'sequence->exp keyword sequence->exp)
  (put 'eval-sequence keyword eval-sequence)
  (put 'eval-dispatch keyword eval-begin)
  "installed sequence")
(install-sequence)

; ;;;and
; (define (install-and)
;   (define keyword 'and)
;   (define (and-actions exp) (cdr exp))
;   (define (no-exp? seq) (null? seq))
;   (define (last-exp? seq) (null? (cdr seq)))
;   (define (first-exp seq) (car seq))
;   (define (rest-exps seq) (cdr seq))
;   (define (eval-and-seq seq env)
;     (cond ((no-exp? seq)
;            true)
;           ((last-exp? seq)
;            (eval (first-exp seq) env))
;           (else
;            (if (eval (first-exp seq) env)
;                (eval-and-seq (rest-exps seq) env)
;                false))))
;   (define (eval-and exp env)
;     (eval-and-seq (and-actions exp) env))
;   (put 'eval-dispatch keyword eval-and)
;   "installed and")
; (install-and)
    
; ;;;or
; (define (install-or)
;   (define keyword 'or)
;   (define (or-actions exp) (cdr exp))
;   (define (no-exp? seq) (null? seq))
;   (define (first-exp seq) (car seq))
;   (define (rest-exps seq) (cdr seq))
;   (define (eval-or-seq seq env)
;     (if (no-exp? seq)
;         false
;         (if (eval (first-exp seq) env)
;             true
;             (eval-or-seq (rest-exps seq) env))))
;   (define (eval-or exp env)
;     (eval-or-seq (or-actions exp) env))
;   (put 'eval-dispatch keyword eval-or)
;   "installed or")
; (install-or)

;;;bool
;下面两行为了兼容gambit
(define true #t)
(define false #f)
(define (true? x)
  (not (eq? x false)))
(define (false? x)
  (eq? x false))

;;;application
(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values 
             (rest-operands exps) 
             env))))

;;;procedure
(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))
(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))
