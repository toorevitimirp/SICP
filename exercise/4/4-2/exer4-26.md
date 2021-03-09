1. 将unless定义为一种语法形式：
（可以修改上一节的求值器，也可以使用宏，这里为了方便将unless定义为一种宏。）
```scheme
(define-syntax unless-syntax
  (syntax-rules ()
    ((unless-syntax condition usual-value exceptional-value)
     (if condition exceptional-value usual-value))))
```
使用unless-sytax定义factorial：
```scheme
(define (factorial n)
  (unless-sytax (= n 1)
          (* n (factorial (- n 1)))
          1))
```
这样定义的factorial是可以运行的。
但是却如Alyssa所言，unless-syntax不能用于高阶函数，否则会报错：
Syntactic keyword may not be used as an expression。

2. Give an example of a situation where it might be useful 
to have unless available as a procedure, rather than as a special form：
```scheme
(define (unless-proc condition usual-value exceptional-value)
  (if condition  exceptional-value usual-value))

(define need-even? '(#t #f #t #f))
(define x '(1 3 5 7))
(define y '(2 4 6 8))
(map unless-proc need-even? x y)
;(2 3 6 7)
```
