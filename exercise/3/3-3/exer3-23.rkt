#lang sicp
(#%require "deque.rkt")
(define deq (make-deque))
(display-deque(front-insert-deque! deq 'a))
(display-deque(front-insert-deque! deq 'b))
(display-deque(rear-insert-deque! deq 'z))
(display-deque(rear-insert-deque! deq 'y))
(display-deque(rear-delete-deque! deq))
(display-deque(front-delete-deque! deq))
(front-deque deq)
(rear-deque deq)