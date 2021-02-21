;为什么不能这么定义：
;https://stackoverflow.com/questions/24529271/sicp-cons-stream
; (define (delay exp)
;   (lambda () exp))

; (define (force delayed-object)
;   (delayed-object))

; (define (cons-stream a b)
;   (cons a (delay b)))

; (define (stream-car stream) 
;   (car stream))

; (define (stream-cdr stream) 
;   (force (cdr stream)))

; (define the-empty-stream '())

; (define (stream-null? s)
;   (null? s))

(define (display-line x)
  (display x)
  (newline))

(define (display-stream s)
  (stream-for-each display-line s))

(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin 
        (proc (stream-car s))
        (stream-for-each proc 
                         (stream-cdr s)))))

; (define (stream-map proc s)
;   (if (stream-null? s)
;       the-empty-stream
;       (cons-stream 
;        (proc (stream-car s))
;        (stream-map proc (stream-cdr s)))))
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc 
                    (map stream-cdr
                         argstreams))))))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))


(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1)
                                  high))))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) 
         the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream 
          (stream-car stream)
          (stream-filter 
           pred
           (stream-cdr stream))))
        (else (stream-filter 
               pred 
               (stream-cdr stream)))))

(define (stream-accumulate op init stream n)
  (if (= 0 n)
      init
      (op (stream-car stream)
          (stream-accumulate op
                      init
                      (stream-cdr stream)
                      (- n 1)))))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (mul-streams s1 s2)
  (stream-map * s1 s2))

(define (scale-stream stream factor)
  (stream-map
   (lambda (x) (* x factor))
   stream))

(define ones (cons-stream 1 ones))

(define integers 
  (cons-stream 1 (add-streams ones integers)))

(define (dsn s n) ;display-stream-n
  (cond ((< n 0)
         (error "n is less equal than 0: "
                "DISPLAY-STREAM-N"))
        ((= n 0)
         'done)
        (else
         (display-line (stream-car s))
         (dsn (stream-cdr s) (- n 1)))))
  