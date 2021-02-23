(load "setup.scm")
;;;let*
; (define (make-let clauses body)
;     (list 'let clauses body))
; (define (let*-clauses exp) (cadr exp))
; (define (let*-body exp) (caddr exp));;;注意和install-let的let-body比较
; (define (first-clause clauses) (car clauses))
; (define (rest-clauses clauses) (cdr clauses))
; (define (no-clauses? clauses) (null? clauses))
; (define (expand-clauses clauses body)
;   (if (no-clauses? clauses)
;       body
;       (make-let
;         (list (first-clause clauses))
;         (expand-clauses (rest-clauses clauses) body))))
; (define (let*->nested-lets exp)
;   (expand-clauses (let*-clauses exp) (let*-body exp)))

; (define exp '(let* ((x 3)
;                     (y (+ x 2))
;                     (z (+ x y 5)))
;                (* x z)))
;;;(display (let*->nested-lets exp))



;;;exercise 4-8
; (let fib-iter ((a 1) (b 0) (count 10))
;     (if (= count 0)
;         b
;         (fib-iter (+ a b) 
;                   a 
;                   (- count 1))))
; (begin
;   (define fib-iter
;     (lambda (a b count)
;       (if (= count 0)
;             b
;             (fib-iter (+ a b) 
;                   a 
;                   (- count 1)))))
;   (fib-iter 1 0 10))

; ((lambda ()
;    (begin
;      (define fib-iter
;        (lambda (a b count)
;          (if (= count 0)
;              b
;              (fib-iter (+ a b) 
;                 a 
;                 (- count 1)))))
;      (fib-iter 1 0 10))))

; (let ⟨var⟩ ⟨bindings⟩ ⟨body⟩)
; (begin
;   (define <var> (lambda <binding variables> <body>))
;   (<var> <binding values>))
; ((lambda ()
;    (begin
;      (define <var> (lambda <binding variables> <body>))
;      (<var> <binding values>))))

; (define (begin-actions exp) (cdr exp))
; (define (last-exp? seq) (null? (cdr seq)))
; (define (first-exp seq) (car seq))
; (define (rest-exps seq) (cdr seq))
; (define (make-lambda parameters body)
;   (cons 'lambda (cons parameters body)))
; (define (make-begin seq) (cons 'begin seq))
; (define (sequence->exp seq)
;     (cond ((null? seq) seq)
;           ((last-exp? seq) (first-exp seq))
;           (else (make-begin seq))))
; (define (named-let? exp) (symbol? (car exp)))
; (define (let-clauses exp)
;   (if (named-let? exp)
;       (caddr exp)
;       (cadr exp)))
; (define (let-body exp)
;   (if (named-let? exp)
;       (cdddr exp)
;       (cddr exp)))
; (define (first-clause clauses) (car clauses))
; (define (rest-clauses clauses) (cdr clauses))
; (define (clause-var clause) (car clause))
; (define (clause-exp clause) (cadr clause))
; (define (make-define name value)(list 'define value))
; (define (let->combination exp)
;   (define (make-call proc-name args) (cons proc-name args))
;   (let ((clauses (let-clauses exp))
;           (body (let-body exp)))
;       (let ((vars (map clause-var clauses))
;             (exps (map clause-exp clauses)))
;         (if (named-let? exp)
;             (list
;              (make-lambda
;                '()
;                (list (sequence->exp
;                       (list (make-define (cadr exp)
;                                          (make-lambda vars body))
;                             (make-call (cadr exp) exps))))))
;              (cons (make-lambda vars body) exps)))))
    
; (define exp
;   '(let fib-iter ((a 1) (b 0) (count 10))
;     (if (= count 0)
;         b
;         (fib-iter (+ a b) 
;                   a 
;                   (- count 1)))))
; (display (let->combination exp))
; (newline)

; (define sequence->exp (get 'sequence->exp 'begin))
; (define make-begin (get 'make-begin 'begin))
; (define make-define (get 'make-define 'define))
; (define make-lambda (get 'make-lambda 'lambda))
; (define make-if (get 'make-if 'if))
; (define (while-predicate exp) (cadr exp))
; (define (while-actions exp) (cddr exp))
; (define (wrap-with-lambda exp) (list (make-lambda '() (sequence->exp exp))))
;   (define (while->combination exp)
;     (let ((proc-name 'while-proc))
;       (wrap-with-lambda
;         (list
;          (list (make-define proc-name
;                             (make-lambda
;                               '()
;                               (list (make-if (while-predicate exp)
;                                        (append
;                                         (cons 'begin (while-actions exp))
;                                         (list (list proc-name)))
;                                        "#while"))))
;                (make-application-call proc-name '()))))))

; (define exp '(while (< i 10) (display i) (set! i (+ i 1))))
