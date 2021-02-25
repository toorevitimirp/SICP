## 一开始的方案

将这样的表达式：

```scheme
(let fib-iter ((a 1) (b 0) (count 10))
    (if (= count 0)
        b
        (fib-iter (+ a b) 
                  a 
                  (- count 1))))
```

转换成这样的表达式：

```scheme
(begin
  (define fib-iter
    (lambda (a b count)
      (if (= count 0)
            b
            (fib-iter (+ a b) 
                  a 
                  (- count 1)))))
  (fib-iter 1 0 10))
```

即完成这样的转换：

```scheme
(let ⟨var⟩ ⟨bindings⟩ ⟨body⟩)
=>
(begin
  (define <var> (lambda <binding variables> <body>))
  (<var> <binding values>))
```

## 问题

查看 <a href="http://community.schemewiki.org/?sicp-ex-4.8">别人的解答</a>后发现这个方案存在一些问题。比如它修改了全局环境：

![1614000498510](/home/toorevitimirp/Desktop/SICP/exercise/4/4-1/pics/1614000498510.png)

## 解决方案

在最外面套一层无参lambda。

即将这样的表达式：

```scheme
(let fib-iter ((a 1) (b 0) (count 10))
    (if (= count 0)
        b
        (fib-iter (+ a b) 
                  a 
                  (- count 1))))
```

转换成这样：

```scheme
((lambda ()
   (begin
     (define fib-iter
       (lambda (a b count)
         (if (= count 0)
             b
             (fib-iter (+ a b) 
                a 
                (- count 1)))))
     (fib-iter 1 0 10))))
```

即完成这样的转换：

```scheme
(let ⟨var⟩ ⟨bindings⟩ ⟨body⟩)
=>
((lambda ()
   (begin
     (define <var> (lambda <binding variables> <body>))
     (<var> <binding values>))))
```

效果：

![1614003355886](pics/1614003355886.png)

## 一个疑问

如果不用define，还有没有其他的转换呢？感觉这个问题和Y组合子有关。

