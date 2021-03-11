 

1. 一开始的版本：

   ```scheme
   (define (text-of-quotation exp env)  
       (let ((text (cadr exp)))
         (if (pair? text) 
             (actual-value (text->lazy-list text) env) 
             text)))
   
    (define (text->lazy-list exp) 
        (if (null? exp) 
            (list 'quote '()) 
            (list 'cons 
                  (list 'quote (car exp)) 
                  (text->lazy-list (cdr exp))))) 
   ```

   只需修改text-of-quotation，增加一个函数text->lazy-list，同时因为text-of-quotation多了一个参数env，所以也要修改eval中调用text-of-quotation的地方。

2. list？

   虽然quote可以用了，但是list却仍然不能用。

   所以为了支持list，在上述修改的基础上，我还修改了quoted?，text-of-quotation，增加了一个函数elements。最终版本如下：

   ```scheme
   ;;;quotation
   (define (quoted? exp)
     (or (tagged-list? exp 'quote)
         (tagged-list? exp 'list)))
   
   (define (elements exp)
     (if (tagged-list? exp 'quote)
         (cadr exp)
         (cdr exp)))
   
   (define (text-of-quotation exp env)  
       (let ((text (elements exp)))
         (if (pair? text) 
             (actual-value (text->lazy-list text) env) 
             text)))
   
    (define (text->lazy-list exp) 
        (if (null? exp) 
            (list 'quote '()) 
            (list 'cons 
                  (list 'quote (car exp)) 
                  (text->lazy-list (cdr exp))))) 
   ```

   