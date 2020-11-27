#lang racket

(provide attach-tag type-tag contents)
;;;标志
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (attach-tag typed-tag contents)
  (cons typed-tag contents))

(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum: 
              TYPE-TAG" datum)))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum: 
              CONTENTS" datum)))