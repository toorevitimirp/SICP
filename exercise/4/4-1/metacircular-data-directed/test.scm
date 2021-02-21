(load "setup.scm")

(define exps
  (list
        'true
        'false
        ''(1 2 3 4 5)                                ;(1 2 3 4 5)
        '(define x 1)                                ;<#definition return#>
        '(set! x 2)                                  ;<#assignment return#>
        '((lambda (x) (* x x)) x)                    ;4
        '(define (append x y)
           (if (null? x)
              y
              (cons (car x) (append (cdr x) y))))    ;<#definition return#>
        '(append '(a b c) '(d e f))                  ;(a b c d e f)
        '(if x 'ok 'fail)
        '(if #t #t #f)                               ;t
        '(cond ((= x 2)
                'ok)
               (else 'fail))                         ;ok
        '(+ (* x x) (+ x 3))                         ;9
        '(begin (+ 1 1) (+ 2 2))                     ;4
        '(and true true false)                       ;#f
        '(and true true true)                        ;#t
        '(and (define a 1) (define b 2))             ;<#definition return#>
        '(and (define a 1) false (define b 2))       ;#f
        '(and )                                      ;#t
        '(or false true false)                       ;#t
        '(or false false false)                      ;#f
        '(or (define a 1) (define b 2))              ;t
        '(or )                                       ;#f
        ))

; (map (lambda (exp) (eval exp the-global-environment)) exps)
(define (test-each exps)
  (if (null? exps)
      'done
      (begin
        (display
         (eval (car exps) the-global-environment))
        (newline)
        (test-each (cdr exps)))))

(test-each exps)