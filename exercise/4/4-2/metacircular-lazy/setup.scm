(load "core.scm")

(define primitive-procedures
  (list 
        (list 'pair? pair?)
        (list 'null? null?)
        (list 'number? number?)
        (list 'string? string?)
        (list 'symbol? symbol?)
        (list 'exit exit)
        (list 'load load)
        (list 'newline newline)
        (list 'display display)
        (list '= =)
        (list '> >)
        (list '< <)
        (list '+ + )
        (list '- - )
        (list '* * )
        (list '/ / )        
        ))

(define builtins
    (list 
    '(define (cons x y) (list "cons" (lambda (m) (m x y))))
    '(define (car z) (z (lambda (p q) p)))
    '(define (cdr z) (z (lambda (p q) q)))
    '(define (list-ref items n)
       (if (= n 0)
           (car items)
           (list-ref (cdr items) (- n 1))))
    
    '(define (map proc items)
       (if (null? items)
           '()
           (cons (proc (car items))
                 (map proc (cdr items)))))
    
    '(define (scale-list items factor)
        (map (lambda (x) (* x factor))
             items))
    
    '(define (add-lists list1 list2)
       (cond ((null? list1) list2)
             ((null? list2) list1)
             (else (cons (+ (car list1) 
                            (car list2))
                         (add-lists
                          (cdr list1) 
                     (cdr list2))))))
    
    '(define ones (cons 1 ones))
    
    '(define integers 
       (cons 1 (add-lists ones integers)))
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
  (define (setup-builtins builtins env)
    (if (null? builtins)
        'ok
        (begin
          (actual-value (car builtins) env)
          (setup-builtins (cdr builtins) env))))
  (let ((initial-env
         (extend-environment 
          (primitive-procedure-names)
          (primitive-procedure-objects)
          the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    (setup-builtins builtins initial-env)
    initial-env))

(define the-global-environment 
  (setup-environment))

