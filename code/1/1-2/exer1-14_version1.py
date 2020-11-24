from graphviz import Digraph


class BiNode(object):
    def __init__(self,id_,label):
        self.id_ = id_
        self.label = label
        self.children = []
        self.father = None

    def __str__(self):
        return str(self.id_)+' ' + str(self.label)
    
    def dfs(self):
        def wrapper(father):
            for child in father.children:
                print(child)
                wrapper(child)
        wrapper(self)


class EdgeDrawer(object):
    """
    EdgeDrawer接收一个list作为参数（CountChange.edges）
    该类解决这样一个问题：给出二叉树先序遍历的edge（head，tail）序列，试图还原该树。
    """
    def __init__(self, edges):
        self._graph = Digraph()
        self._root = BiNode('0',edges[0][0])

        father = self._root
       
        index = 0
        count = 1
        for heads, tail in edges:
            child = BiNode(str(count), tail)
            count += 1
            father.children.append(child)
            child.father = father
            
            if (index+1) < len(edges):
                next_head = edges[index+1][0]
                next_tail = edges[index+1][1]
            if tail == next_head:
                father = child
            else:
                while child.father.label != next_head:
                    child = child.father
                father = child.father
            index +=1

    def draw(self):
        def init(father):
            self._graph.node(father.id_, father.label)
            for child in father.children:
                self._graph.node(child.id_, child.label)
                self._graph.edge(father.id_, child.id_)
                init(child)
        init(self._root)
        self._graph.render('test',format='png',cleanup=True, view=True)


class CountChange(object):

    def __init__(self, amount, kinds_of_coins=5):
        self.amount = amount
        self.kinds_of_coins = kinds_of_coins
        self._first_denomination = [1,5,10,25,50]
        self._edges = []
        self._answer = self.change_count_edge()
        print(self._answer)

    def change_count_edge(self):
        def wrapper(amount, kinds_of_coins,pre_name):

            current_name = '('+ str(amount)+','+str(kinds_of_coins)+')'
            self._edges.append((pre_name, current_name))

            if amount == 0:
                return 1
            elif (amount < 0) or (kinds_of_coins == 0):
                return 0
            else:
                new_amount = amount-self._first_denomination[kinds_of_coins-1]
                return  wrapper(amount, (kinds_of_coins - 1), current_name) + \
                        wrapper(new_amount, kinds_of_coins, current_name)

        name = 'CountChange' + str(self.kinds_of_coins)
        return wrapper(self.amount,self.kinds_of_coins,name)
    
    
    @property
    def answer(self):
        return self._answer

    @property
    def edges(self):
        return self._edges
   
cc = CountChange(50)
ed = EdgeDrawer(cc.edges)
ed.draw()
