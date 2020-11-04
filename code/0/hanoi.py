class Rod(object):
    def __init__(self,name, disks):
        self.name = name
        self.disks_stack = disks

class Hanoi(object):

    def __init__(self, n):
        self.n = n

        self.from_ = Rod("a",[n-i for i in range(n)])
        self.to = Rod("c",[])
        self.temp = Rod("b",[])

        self.count = 0

    def introspect(self):
        print(self.from_.name,end=":")
        print(self.from_.disks_stack)

        print(self.temp.name,end=":")
        print(self.temp.disks_stack)

        print(self.to.name,end=":")
        print(self.to.disks_stack)
        print("="*50)

    def recursive_run(self):
        def move(n, from_, to):
            # print("%d:%s->%s"%(n, from_.name, to.name))
            self.count += 1
            disk = from_.disks_stack.pop()
            to.disks_stack.append(disk)
            self.introspect()

        def wrapper(n, from_, to, temp):
            if n==1:
                move(n, from_, to)
            else:
                wrapper(n-1, from_, temp, to)
                move(n, from_, to)
                wrapper(n-1, temp, to,from_)
        self.introspect()
        wrapper(self.n, self.from_,
                self.to, self.temp)

    def iter_run(self):
        pass

hanoi = Hanoi(5)
hanoi.recursive_run()
print(hanoi.count)