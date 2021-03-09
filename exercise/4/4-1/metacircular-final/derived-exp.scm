(load "basic-exp.scm")


;;;cond
(define (cond? exp)
  (tagged-list? exp 'cond))

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
              (else (make-if (cond-predicate first)
                             (sequence->exp
                              (cond-actions first))
                             (expand-clauses rest)))))))


;;;let
(define (let? exp)
  (tagged-list? exp 'let))

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
