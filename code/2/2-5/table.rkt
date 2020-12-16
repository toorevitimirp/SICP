#lang sicp

(#%require "type.rkt")

(#%provide put get put-coercion  get-coercion apply-generic)

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable 
             (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record 
                   (assoc key-2 
                          (cdr subtable))))
              (if record (cdr record) false))
            false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable 
             (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record 
                   (assoc key-2 
                          (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! 
                   subtable
                   (cons (cons key-2 value)
                         (cdr subtable)))))
            (set-cdr! 
             local-table
             (cons (list key-1
                         (cons key-2 value))
                   (cdr local-table))))))
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation: 
                          TABLE" m))))
    dispatch))

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

(define (put-coercion source-type target-type proc)
  (put 'coercion (list source-type target-type) proc))

(define (get-coercion source-type target-type)
  (get 'coercion (list source-type target-type)))

; (define (apply-generic op . args)
;   (let ((type-tags (map type-tag args)))
;     (let ((proc (get op type-tags)))
;       (if proc
;           (apply proc (map contents args))
;           (error
;             "No method for these types: 
;              APPLY-GENERIC"
;             (list op type-tags))))))

(define (apply-generic op . args)
   (define (types args) (map type-tag args))
   (define (work? coercions)
      (if (null? coercions)
          true
          (and (car coercions)
              (work? (cdr coercions)))))
   (define (iter remain-types)
      (if (null? remain-types)
          (error "No coersion strategy for these types " (list op (types)))
          (let ((coercions
                 (map (lambda (type)
                        (if (equal? type (car remain-types))
                            (lambda (x) x)
                            (get-coercion type (car remain-types))))
                      (types args))))
            (if (work? coercions)
                ; (apply-generic op
                ;  (map (lambda (coercer arg)
                ;         (coercer arg))
                ;       coercions
                ;       args))
                (let ((new-args
                       (map (lambda (coercer arg)
                              (coercer arg))
                            coercions
                            args)))
                  (let ((proc (get op (types new-args))))
                    (apply proc new-args)))
                 
                (iter (cdr remain-types))))))
   (let ((proc (get op (types args)))) 
         (if proc 
             (apply proc (map contents args)) 
             (iter (types args)))))