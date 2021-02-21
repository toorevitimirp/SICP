## 遇到一个问题
![1613901645266](pics/LICENSE)

因为#t和#f既不是self-evaluating?也不是variable?。

## 解决办法

修改self-evaluating？函数：

```scheme
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        ((eq? exp '#t) true)
        ((eq? exp '#f) true)
        (else false)))
```

## #t和true，#f和false的关系

