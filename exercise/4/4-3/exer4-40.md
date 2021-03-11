我觉得这个问题有值得深入思考。
我的猜想是，分支少的回溯节点应该位于回溯树的上面。用树来思考回溯是显然的，但是我目前还没有仔细思考回溯树这个概念。
```scheme
  (define (nested-multiple-dwelling) 
    (let ((fletcher (amb 1 2 3 4 5))) 
        (require (not (= fletcher 5))) 
        (require (not (= fletcher 1)))
        (let ((baker (amb 1 2 3 4 5)))
             (require (not (= baker 5))) 
             (let ((cooper (amb 1 2 3 4 5)))
                  (require (not (= cooper 1))) 
                  (let ((miller (amb 1 2 3 4 5))) 
                       (require (> miller cooper)) 
                       (let (smith (amb 1 2 3 4 5)) 
                            (require (not (= (abs (- fletcher cooper)) 1))) 
                            (require (not (= (abs (- smith fletcher)) 1))) 
                            (require 
                             (distinct? (list baker cooper fletcher miller smith))) 
                            (list (list 'baker baker) 
                            (list 'cooper cooper) 
                            (list 'fletcher fletcher) 
                            (list 'miller miller) 
                            (list 'smith smith))))))) 
```