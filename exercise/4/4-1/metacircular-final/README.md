## 求值器的组成

1. utils : 一些帮助函数。

2. env-pair-frame : 环境、frame(*a pair of lists*)的表示和操作。

   env-list-frame : 环境、frame(*a list of bindings*)的表示和操作。

3. basic-exp : 基本表达式。

4. derived-exp : 派生表达式。精力有限，只完成了书中要求的let、cond表达式。

5. core : analyze和execute-application的定义。

6. setup : 初始化，定义primitive-procedures和the-global-environment。

7. repl : ReadEvalPrintLoop。

依赖关系是：7->6->5->4->3->2(任意一个)->1。

## 其它

1. metacircular-test : 测试求值器能否正确运行，其中包含了很多测试用例。