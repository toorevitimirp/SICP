#lang racket


;;;define-syntax-rule

(define-syntax-rule (swap x y)
  (let ([tmp x])
    (set! x y)
    (set! y tmp)))


;;;define-syntax and syntax-rules

;2 or 3 arguments
; (define-syntax rotate
;   (syntax-rules ()
;     [(_ a b) (swap a b)]
;     [(_ a b c) (begin
;                      (swap a b)
;                      (swap b c))]))

;3 or more arguments
; (define-syntax rotate
;   (syntax-rules ()
;     [(rotate a) (void)]
;     [(rotate a b c ...) (begin
;                           (swap a b)
;                           (rotate b c ...))]))

;more efficient 
(define-syntax rotate
  (syntax-rules ()
    [(rotate a c ...)
     (shift-to (c ... a) (a c ...))]))
(define-syntax shift-to
  (syntax-rules ()
    [(shift-to (from0 from ...) (to0 to ...))
     (let ([tmp from0])
       (set! to from)
       ...
       (set! to0 tmp))]))


;;;Identifier Macros

 (define-syntax val
    (lambda (stx)
      (syntax-case stx ()
        [val (identifier? (syntax val))
             (syntax (get-val))])))
(define-values (get-val put-val!)
    (let ([private-val 0])
      (values (lambda () private-val)
              (lambda (v) (set! private-val v)))))

;set! transformers
(define-syntax val2
    (make-set!-transformer
     (lambda (stx)
       (syntax-case stx (set!)
         [val2 (identifier? (syntax val2)) (syntax (get-val))]
         [(set! val2 e) (syntax (put-val! e))]))))


;;;Macro-Generating Macros
(define-syntax-rule (define-get/put-id id get put!)
    (define-syntax id
      (make-set!-transformer
       (lambda (stx)
         (syntax-case stx (set!)
           [id (identifier? (syntax id)) (syntax (get))]
           [(set! id e) (syntax (put! e))])))))


;;;syntax-case
(define-syntax (swap stx)
  (syntax-case stx ()
    [(swap x y)
     (if (and (identifier? #'x)
              (identifier? #'y))
         #'(let ([tmp x])
             (set! x y)
             (set! y tmp))
         (raise-syntax-error #f
                             "not an identifier"
                             stx
                             (if (identifier? #'x)
                                 #'y
                                 #'x)))]))

