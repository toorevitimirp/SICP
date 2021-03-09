假设序列有四个表达式，那么正文中的analyze-sequence给出的结果是：

```scheme
(lambda (env)
  ((lambda (env)
     ((lambda (env)
        (proc1 env)
        (proc2 env))
      env)
     (proc3 env))
   env)
  (proc4 env))
```

Alyssa的analyze-sequence给出的结果是：

```scheme
(lambda (env)
  (execute-sequence (proc1 proc2 proc3 proc4) env)) 
```

这个版本的analyze-sequence在运行时调用execute-sequence对表达式序列求值，会比较低效。

