(load "setup.scm")

; (define (make-chcker expr res)
;   (cons expr res))
; (define (chcker-exprs chcker) (car chcker))
; (define (chcker-res chcker) (cdr chcker))
; (define (add-test! expr res chcker)
;   (set-car! chcker (cons expr (chcker-exprs chcker)))
;   (set-cdr! chcker (cons res (chcker-res chcker))))
; (define (chcke chcker)
;   (let ((eval_res
;          (map (lambda (expr)
;                 (eval_ expr the-global-environment))
;               (chcker-exprs chcker))))
;     (map eq? eval_res (chcker-res chcker))))

; (define exprs
;   (list
;         'true                                        ;t
;         'false                                       ;f
;         ''(1 2 3 4 5)                                ;(1 2 3 4 5)
;         '(define x 1)                                ;#definition
;         '(set! x 2)                                  ;#assignment
;         '((lambda (x) (* x x)) x)                    ;4
;         '(define (append x y)
;            (if (null? x)
;               y
;               (cons (car x) (append (cdr x) y))))    ;#definition
;         '(append '(a b c) '(d e f))                  ;(a b c d e f)
;         '(if x 'ok 'fail)
;         '(if #t #t #f)                               ;t
;         '(cond ((= x 2)
;                 'ok)
;                (else 'fail))                         ;ok
;         '(+ (* x x) (+ x 3))                         ;9
;         '(begin (+ 1 1) (+ 2 2))                     ;4
;         '(and true true false)                       ;#f
;         '(and true true true)                        ;#t
;         '(and (define a 1) (define b 2))             ;#definition
;         '(and (define a 1) false (define b 2))       ;#f
;         '(and )                                      ;#t
;         '(or false true false)                       ;#t
;         '(or false false false)                      ;#f
;         '(or (define a 1) (define b 2))              ;#t
;         '(or )                                       ;#f
;         '(cond ((cdr (cons 'a x))
;                 => (lambda (x) x))
;                (else false))                         ;2
;         '(let ((x 4) (y 3))
;            (let ((z 5))
;              (* x y z)(+ x y z)))                    ;12
;         '(let* ((x 3)
;                 (y (+ x 2))
;                 (z (+ x y 5)))
;            (+ x y)(* x z))                           ;39
;         '(let fib-iter ((a 1) (b 0) (count 10))
;            (if (= count 0)
;                b
;                (fib-iter (+ a b) 
;                      a 
;                      (- count 1))))                 ;55
;         '(define i 0)                               ;#definition
;         '(while (< i 10)
;             (display i) (set! i (+ i 1)))           ;0123456789#while
;   ))

; (define res
;   (list
;         #t
;         #f
;         '(1 2 3 4 5)
;         "#definition"
;         "#assignment"
;         4
;         "#definition"
;         '(a b c d e f)
;         'ok
;         #t
;         'ok
;         9
;         4
;         #f
;         #t
;         "#definition"
;         #f
;         #t
;         #t
;         #f
;         #t
;         #f
;         2
;         12
;         39
;         55
;         "#definition"
;         "#while"
;         ))

; (define the-chcker (make-chcker exprs res))
; (newline)
; (display (chcke the-chcker))
; (newline)

(define exprs
  (list
        'true                                        ;t
        'false                                       ;f
        ''(1 2 3 4 5)                                ;(1 2 3 4 5)
        '(define x 1)                                ;#definition
        '(set! x 2)                                  ;#assignment
        '((lambda (x) (* x x)) x)                    ;4
        '(define (append x y)
           (if (null? x)
              y
              (cons (car x) (append (cdr x) y))))    ;#definition
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
        '(and (define a 1) (define b 2))             ;#definition
        '(and (define a 1) false (define b 2))       ;#f
        '(and )                                      ;#t
        '(or false true false)                       ;#t
        '(or false false false)                      ;#f
        '(or (define a 1) (define b 2))              ;#t
        '(or )                                       ;#f
        '(cond ((cdr (cons 'a x))
                => (lambda (x) x))
               (else false))                         ;2
        '(let ((x 4) (y 3))
           (let ((z 5))
             (* x y z)(+ x y z)))                    ;12
        '(let* ((x 3)
                (y (+ x 2))
                (z (+ x y 5)))
           (+ x y)(* x z))                           ;39
        '(let fib-iter ((a 1) (b 0) (count 10))
           (if (= count 0)
               b
               (fib-iter (+ a b) 
                     a 
                     (- count 1))))                 ;55
        '(define i 0)                               ;#definition
        '(while (< i 10)
            (display i) (set! i (+ i 1)))           ;0123456789#while
  ))

(define (test-each exprs)
  (if (null? exprs)
      'done
      (begin
        (display
         (eval_ (car exprs) the-global-environment))
        (newline)
        (test-each (cdr exprs)))))

(test-each exprs)