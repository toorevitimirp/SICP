1. Why simply replacing an-integer-between by an-integer-starting-from in the procedure in Exercise 4.35 is not an adequate way to generate arbitrary Pythagorean triples?

   因为如果用an-integer-starting-from代替an-integer-between，只要require失败后，程序会回溯到重新选择k的值。这样的话，i和j的值永远不会被重新选择。

2. 

```scheme
(define (a-pythagorean-triple-between)
  (let ((i (an-integer-starting-from 1)))
    (let ((j (an-integer-between i (+ i 10))))
      (let ((k (an-integer-between j (+ j 10))))
        (require (= (+ (* i i) (* j j)) 
                    (* k k)))
        (list i j k)))))
```
