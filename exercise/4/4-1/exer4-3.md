* 代码在metacircular-data-directed/里。

* 我觉得basic-exp.scm和derived-exp.scm的代码有点不优雅，有些语法要install，有些不要。

* 实现的过程遇到一个问题：重复load一个文件会覆盖掉原来已经load的文件。

  详见下图。在main里面(modifed? g)返回的应该是false。

![1613890335506](pics/1613890335506.png)