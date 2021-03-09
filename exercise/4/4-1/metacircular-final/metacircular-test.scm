(load "setup.scm")

(define (make-chcker expr res)
  (cons expr res))

(define (chcker-exprs chcker) (car chcker))

(define (chcker-res chcker) (cdr chcker))

(define (add-test! expr res chcker)
  (set-car! chcker
            (append (chcker-exprs chcker) (list expr)))
  (set-cdr! chcker
            (append (chcker-res chcker) (list res))))

(define (chcke chcker)
  (let ((exprs (chcker-exprs chcker))
        (expects (chcker-res chcker)))
    (define (test-each exprs expects)
      (if (null? exprs)
          "all passed"
          (let ((expr (car exprs))
                (expct (car expects)))
            (display expr)
            (display " => ")
            (let ((eval-res (eval_ expr the-global-environment)))
              (if (equal? eval-res expct)
                  (begin
                    (display "pass\n")
                    (test-each (cdr exprs) (cdr expects)))
                  (begin
                    (display "fail\n")
                    "fail"))))))
    (test-each exprs expects)))

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
        '(let ((x 7) (y 8)) (+ x y) (* x y))         ;56
        '(define (fib n)
           (let fib-iter ((a 1) (b 0) (count n))
             (if (= count 0)
                 b
                 (fib-iter (+ a b) 
                           a 
                           (- count 1)))))          ;#definition
        '(fib 10)                                   ;55
        ))

(define res
  (list #t
        #f
        '(1 2 3 4 5)
        "#definition"
        "#assignment"
        4
        "#definition"
        '(a b c d e f)
        'ok
        #t
        'ok
        9
        4
        56
        "#definition"
        55
        ))


(define the-chcker (make-chcker exprs res))

(newline)
(chcke the-chcker)