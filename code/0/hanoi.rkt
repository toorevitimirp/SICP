#lang sicp


(define count 0)

(define (move n from to)
  (set! count (+ count 1))
  (display n)
  (display ": ")
  (display from)
  (display "->")
  (display to)
  (newline))


(define (current-status n from to temp)
  (display n)
  (display " ")
  (display from)
  (display " ")
  (display to)
  (display " ")
  (display temp)
  (newline))


(define (hanoi-computer n from to temp)
  (current-status n from to temp)
  (cond ((= n 1) (move 1 from to))
        (else (hanoi-computer (- n 1) from temp to)
              (move n from to)
              (hanoi-computer (- n 1) temp to from))))


(define (hanoi-human from to temp n)
  ("pass"))

(hanoi-computer 5 "a" "c" "b")