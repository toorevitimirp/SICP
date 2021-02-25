(load "basic-exp.scm")


;;;cond
(define (install-cond)
  (define keyword 'cond)
  (define (cond-clauses exp) (cdr exp))
  (define (cond-else-clause? clause)
    (eq? (cond-predicate clause) 'else))
  (define (cond-predicate clause) 
    (car clause))
  (define (cond-actions clause) 
    (cdr clause))
  (define (cond->if exp)
    (expand-clauses (cond-clauses exp)))
  (define (expand-clauses clauses)
    (if (null? clauses)
        'false     ; no else clause
        (let ((first (car clauses))
              (rest (cdr clauses)))
          (cond ((cond-else-clause? first)
                 (if (null? rest)
                     (sequence->exp
                      (cond-actions first))
                     (error "ELSE clause isn't 
                            last: COND->IF"
                            clauses)))
                ((eq? (car (cond-actions first)) '=>)
                 (if (null? (cdr (cond-actions first)))
                     (error "Ill-formed syntax: (cond (... =>) ...)")
                     (let ((test (cond-predicate first))
                           (recipient (cadr (cond-actions first))))
                       (make-if test
                                (list recipient test)
                                (expand-clauses rest)))))
                 (else
                  (make-if (cond-predicate first)
                           (sequence->exp
                            (cond-actions first))
                           (expand-clauses rest)))))))
  (define (eval-cond exp env)
    (eval_ (cond->if exp) env))
  (put 'eval-dispatch 'cond eval-cond)
  "installed cond")
(install-cond)


;;;and
(define (install-and)
  (define keyword 'and)
  (define (last-seq? seq) (null? (cdr seq)))
  (define (and-seq exp) (cdr exp))
  (define (first-seq seq) (car seq))
  (define (rest-seq seq) (cdr seq))
  (define (and->if exp)
    (expand-seq (and-seq exp)))
  (define (expand-seq seq)
    (cond ((null? seq) true)
          ((last-seq? seq)
           (make-if (first-seq seq) (first-seq seq) false))
          (else (make-if
                  (first-seq seq)
                  (expand-seq (rest-seq seq))
                  false))))
  (define (eval-and exp env)
    (eval_ (and->if exp) env))
  (put 'eval-dispatch keyword eval-and)
  "installed and")
(install-and)
        
;;;or
(define (install-or)
  (define keyword 'or)
  (define (no-seq? seq) (null? seq))
  (define (or-seq exp) (cdr exp))
  (define (first-seq seq) (car seq))
  (define (rest-seq seq) (cdr seq))
  (define (expand-seq seq)
    (if (no-seq? seq)
        false
        (make-if (first-seq seq)
                 true
                 (expand-seq (rest-seq seq)))))
  (define (or->if exp)
    (expand-seq (or-seq exp)))
  (define (eval-or exp env)
    (eval_ (or->if exp) env))
  (put 'eval-dispatch keyword eval-or)
  "installed or")
(install-or)

;;;let
(define (install-let)
  (define keyword 'let)
  (define (named-let? exp) (symbol? (cadr exp)))
  (define (let-clauses exp)
    (if (named-let? exp)
        (caddr exp)
        (cadr exp)))
  (define (let-body exp)
    (if (named-let? exp)
        (cdddr exp)
        (cddr exp)))
  (define (first-clause clauses) (car clauses))
  (define (rest-clauses clauses) (cdr clauses))
  (define (clause-var clause) (car clause))
  (define (clause-exp clause) (cadr clause))
  (define (let->combination exp)
    (let ((clauses (let-clauses exp))
          (body (let-body exp)))
      (let ((vars (map clause-var clauses))
            (exps (map clause-exp clauses)))
        (if (named-let? exp)
            (list
             (make-lambda
               '()
               (list (sequence->exp
                      (list (make-define (cadr exp)
                                         (make-lambda vars body))
                       (make-application-call (cadr exp) exps))))))
            (cons (make-lambda vars body) exps)))))
  (define (eval-let exp env)
    (let ((new-exp (let->combination exp)))
      (eval_ new-exp env)))
  (define (make-let clauses body)
    (list keyword clauses body))
  (put 'make-let keyword make-let)
  (put 'eval-dispatch keyword eval-let)
  "installed let")

(install-let)
(define make-let (get 'make-let 'let))


;;;let*
(define (install-let*)
  (define keyword 'let*)
  (define (let*-clauses exp) (cadr exp))
  (define (let*-body exp) (cddr exp))
  (define (first-clause clauses) (car clauses))
  (define (rest-clauses clauses) (cdr clauses))
  (define (no-clauses? clauses) (null? clauses))
  (define (expand-clauses clauses body)
    (if (no-clauses? clauses)
        (sequence->exp body)
        (make-let
        (list (first-clause clauses))
          (expand-clauses (rest-clauses clauses) body))))
  (define (let*->nested-lets exp)
    (expand-clauses (let*-clauses exp) (let*-body exp)))
  (define (eval-let* exp env)
    (eval_ (let*->nested-lets exp) env))
  (put 'eval-dispatch keyword eval-let*)
  "installed let*")
(install-let*)


;;;while
;(while (< i 10) (display i) (set! i (+ i 1)))
; ((lambda ()
;    (begin
;      (define while-func
;        (lambda () (if (< i 10) (begin(display i) (set! i (+ i 1)) (while-func) "#while"))))
;      (while-func))))
(define (install-while)
  (define keyword 'while)
  (define (while-predicate exp) (cadr exp))
  (define (while-actions exp) (cddr exp))
  (define (wrap-with-lambda exp) (list (make-lambda '() (sequence->exp exp))))
  (define (while->combination exp)
    (let ((proc-name 'while-proc))
      (wrap-with-lambda
        (list
         (list (make-define proc-name
                            (make-lambda
                              '()
                              (list (make-if (while-predicate exp)
                                       (append
                                        (cons 'begin (while-actions exp))
                                        (list (list proc-name)))
                                       "#while"))))
               (make-application-call proc-name '()))))))
  (define (eval-while exp env)
    (eval_ (while->combination exp) env))
  (put 'eval-dispatch keyword eval-while)
  "installed while")

(install-while)