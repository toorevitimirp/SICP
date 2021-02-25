主要讲b)。

## 要求

将

```scheme
（(define u ⟨e1⟩)
  (define v ⟨e2⟩)
  ⟨e3⟩)
```

转换成

```scheme
((let ((u '*unassigned*)
        (v '*unassigned*))
    (set! u ⟨e1⟩)
    (set! v ⟨e2⟩)
    ⟨e3⟩))
```

## 一开始的解答

```scheme
(define (scan-out-defines body)
    
    (define (all-defines internal)
        (cond ((null? internal) '())
        ((tagged-list? (car internal) 'define)
         (cons (cons (definition-variable (car internal))
                     (list (definition-value (car internal))))
               (all-defines (cdr internal))))
        (else (all-defines (cdr internal)))))
    
    (define (value-exprs internal)
        (cond ((null? internal) '())
        ((tagged-list? (car internal) 'define)
         (value-exprs (cdr internal)))
        (else (cons (car internal)
                    (value-exprs (cdr internal))))))
    
    (let ((defines (all-defines body))
          (values (value-exprs  body)))
        (list (make-let
                (map (lambda (p)
                       (list (car p)
                             '*unassigned*))
                     defines)
                (sequence->exp
                 (append (map (lambda (p)
                                (list 'set! (car p) (cadr p)))
                              defines)
                         values))))))
```

在测试下面这样的代码时出现死循环。

```scheme
(define x 2)
((lambda (*x*) (* x x)) x) 
```

后来查看别人的代码时，发现如果块结构里没有define语句，那么(scan-out-defines *body*)应该直接返回body。

我并不知道为什么这样就解决了死循环。

修改后代码如下：

```scheme
(define (scan-out-defines body)
    
    (define (all-defines internal)
        (cond ((null? internal) '())
        ((tagged-list? (car internal) 'define)
         (cons (cons (definition-variable (car internal))
                     (list (definition-value (car internal))))
               (all-defines (cdr internal))))
        (else (all-defines (cdr internal)))))
    
    (define (value-exprs internal)
        (cond ((null? internal) '())
        ((tagged-list? (car internal) 'define)
         (value-exprs (cdr internal)))
        (else (cons (car internal)
                    (value-exprs (cdr internal))))))
    
    (let ((defines (all-defines body))
          (values (value-exprs  body)))
      (if (null? defines)
          body
          (list (make-let
                  (map (lambda (p)
                         (list (car p)
                               '*unassigned*))
                       defines)
                  (sequence->exp
                   (append (map (lambda (p)
                                  (list 'set! (car p) (cadr p)))
                                defines)
                           values)))))))
```

## 新的问题

课本上这种解决方案是有问题的。

定义迭代式的斐波那契函数如下：

```scheme
(define fib
    (lambda (n)
      (define (fib-iter a b count)
          (if (= count 0)
          b
          (fib-iter (+ a b) a (- count 1))))
           (fib-iter 1 0 n)))
```

那么按照课本的方案，上述代码应该转换成下面这样：

```scheme
(define fib
    (lambda (n)
      (let ((fib-iter '*unassigned*))
        (set! fib-iter
              (lambda (a b count)
                (if (= count 0)
                b
                (fib-iter (+ a b) a (- count 1)))))
        (fib-iter 1 0 n))))
```

当解释器解释到第8行的时候发现fib-iter的值是'\*unassigned\*，报错。

也就是说，当块结构内部定义了一个引用自身的递归函数时，课本给出的方案将报错。

## 我自己的解决方案

采用命名let，将

```scheme
(define fib
    (lambda (n)
      (define (fib-iter a b count)
          (if (= count 0)
          b
          (fib-iter (+ a b) a (- count 1))))
           (fib-iter 1 0 n)))
```

转换成这样：

```scheme
(define fib
    (lambda (n)
      (let fib-iter ((a 1) (b 0) (count n))
        (if (= count 0)
            b
            (fib-iter (+ a b) 
                  a 
                  (- count 1))))))
```

但是这种方案似乎会遇到新的问题，我还没有用代码实现。