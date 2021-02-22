对这个问题不是很理解：
```
If we have already implemented let (Exercise 4.6) 
and we want to extend the evaluator to handle let*, 
is it sufficient to add a clause to eval whose 
action is

(eval (let*->nested-lets exp) env)

or must we explicitly expand let* in terms of 
non-derived expressions?
```
我的实现方法使用(eval (let*->nested-lets exp) env)完全没有问题。