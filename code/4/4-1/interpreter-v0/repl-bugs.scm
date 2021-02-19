(load "setup.scm")
; (define input-prompt  ";;; M-Eval input:")
; (define output-prompt ";;; M-Eval value:")
(define input-prompt  "in[")
(define output-prompt "out[")

(define (pretty-read)
  (display "_> ")
  (read))

(define (driver-loop in-count out-count)
  (prompt-for-input in-count input-prompt)
  (let ((input (read)))
    (display (car input))
    (let ((output 
           (eval input 
                 the-global-environment)))
      (announce-output out-count output-prompt)
      (user-print output)))
  (driver-loop (+ in-count 1) (+ out-count 1)))

(define (prompt-for-input in-count string)
  (newline)
  (newline)
  ; (display "_____________________________________")
  (newline)
  (display string)
  (display in-count)
  (display "]: ")
  (newline)
  (newline)
  )

(define (announce-output out-count string)
  (newline)
  (display string)
  (display out-count)
  (display "]: ")
  (newline))

(define (user-print object)
  (if (compound-procedure? object)
      (display 
       (list 'compound-procedure
             (procedure-parameters object)
             (procedure-body object)
             '<procedure-env>))
      (display object)
      ))

(driver-loop 0 0)