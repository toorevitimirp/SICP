1. 先说结论：在枚举了所有可能的时候，耗时长的require应该放在后面。
```scheme
...
(require
     (distinct? (list baker cooper fletcher 
                      miller smith)))
(require (not (= baker 5)))
(require (not (= cooper 1)))
(require (not (= fletcher 5)))
(require (not (= fletcher 1)))
(require (> miller cooper))
(require
    (not (= (abs (- smith fletcher)) 1)))
(require 
    (not (= (abs (- fletcher cooper)) 1)))
...
```
​		在上述各个require中，第一个require耗时最长，其余的耗时差不多。所以代码应该改成：

```scheme
...
(require (not (= baker 5)))
(require (not (= cooper 1)))
(require (not (= fletcher 5)))
(require (not (= fletcher 1)))
(require (> miller cooper))
(require
    (not (= (abs (- smith fletcher)) 1)))
(require 
    (not (= (abs (- fletcher cooper)) 1)))
(require
     (distinct? (list baker cooper fletcher 
                      miller smith)))
...
```

2. 为什么？

   此题共枚举了5^5种可能，每一行require的作用是检查一种可能，如果通过，则进入下一句require的检查，不通过则从头开始检查下一种可能。

   所以越后面的require检查被调用的次数越少。

   因此为了让程序效率更高，耗时长的require应该放在后面。