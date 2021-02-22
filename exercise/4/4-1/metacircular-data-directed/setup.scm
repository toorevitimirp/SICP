(load "core.scm")

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'pair? pair?)
        (list 'null? null?)
        (list 'number? number?)
        (list 'string? string?)
        (list 'symbol? symbol?)
        (list 'exit exit)
        (list 'load load)
        (list 'display display)
        (list '= =)
        (list '> >)
        (list '< <)
        (list '+ + )
        (list '- - )
        (list '* * )
        (list '/ / )        
        ))
(define (primitive-procedure-names)
  (map car primitive-procedures))
(define (primitive-implementation proc) 
  (cadr proc))
(define (primitive-procedure-objects)
  (map (lambda (proc) 
         (list 'primitive (cadr proc)))
       primitive-procedures))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

(define (setup-environment)
  (let ((initial-env
         (extend-environment 
          (primitive-procedure-names)
          (primitive-procedure-objects)
          the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))

(define the-global-environment 
  (setup-environment))

;;;for inspectation
(define env the-global-environment)

