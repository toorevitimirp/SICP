```scheme
(define (id x) x)

(define (map f l)
  (if (null? l)
      '()
      (cons (f (car l)) (map f (cdr l)))))

(map id '(1 2 3))
```
这种情况之所以要用actual-value而不是eval是因为id在求值器中被delay了，变成了(thunk id the-globa-environment)。