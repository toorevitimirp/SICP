```scheme
(define w (id (id 10)))
```

输出上面一行后发生了如下的事：

```scheme
(eval-definition '(define w (id (id 10))) the-global-environment)

(eval '(id (id 10)) the-global-environment)

(apply (actual-value 'id the-global-environment)
       '(id 10)
       the-global-environment)

(apply '(lambda (x) (set! count (+ count 1)) x)
       '(id 10) the-global-environment)

(eval-sequence '((set! count (+ count 1)) x) 
               '(thunk (id 10)) 
               the-global-environment)
```

这时候 (set! count (+ count 1)) 被执行了一次，所以输入在REPL中输入count会返回1。

而w在the-global-environment的值是上述第12行的返回值，也就是'(thunk (id 10) the-global-environment)。

当我们再在REPL中输入w：

```scheme
(actual-value 'w the-global-environment)
(force-it (eval 'w the-global-environment))
(force-it '(thunk (id 10) the-global-environment))
(actual-value '(id 10) the-global-environment)
```

上述第4行会再一次执行(set! count (+ count 1)，同时返回10。