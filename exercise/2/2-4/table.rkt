
#lang racket

(provide *the-table* put get)

(define *the-table* (make-hash));make THE table

(define (put key1 key2 value)
  (hash-set! *the-table* (list key1 key2) value));put

(define (get key1 key2)
   (hash-ref *the-table* (list key1 key2) #f));get 