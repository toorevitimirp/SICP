显然，在应用序语言中，计算(factorial 5)会导致死循环。
在正则序语言中，用代换法则计算(factorial 3) *((factorial 5)展开太长了)* 展开如下：
```scheme
(factorial 3)
(unless (= 3 1) (* 3 (factorial (- 3 1))) 1)
(if (= 3 1) 1 (* 3 (factorial (- 3 1))))
(* 3 (unless (= 2 1 ) (* 2 (factorial (- 2 1) 1))) 1)
(* 3 (if (= 2 1 ) (* 2 (factorial 1)) 1))
(* 3 (* 2 (factorial 1)))
(* 3 (* 2 (unless (= 1 1) (factorial (- 1 1)) 1)))
(* 3 (* 2 (if (= 1 1) 1 (factorial 0))))
(* 3 (* 2 1))
```
在上述展开中，我们遇到整数的运算就直接求值。
