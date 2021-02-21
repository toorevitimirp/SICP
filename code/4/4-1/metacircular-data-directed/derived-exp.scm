;;;cond
(load "basic-exp.scm")

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
          (if (cond-else-clause? first)
              (if (null? rest)
                  ((get 'sequence->exp  'begin)
                   (cond-actions first))
                  (error "ELSE clause isn't 
                         last: COND->IF"
                         clauses))
              ((get 'make-if 'if)
               (cond-predicate first)
               ((get 'sequence->exp  'begin)
                (cond-actions first))
                       (expand-clauses 
                        rest))))))
  (define (eval-cond exp env)
    ((get 'eval-dispatch 'if)
     (cond->if exp)
     env))
  (put 'eval-dispatch 'cond eval-cond)
  "installed cond")

;;;install syntax
(install-cond)
