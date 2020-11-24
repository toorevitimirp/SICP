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


class NodeDrawer(object):
    def __init__(self, root):
        self._graph = Digraph()
        self._root = root

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
        self._root = None
        self._answer = self.change_count_node()
        print(self._answer)

    def change_count_node(self):
        count = 1
        def wrapper(amount, kinds_of_coins,father):
            nonlocal count

            current_name = '('+ str(amount)+','+str(kinds_of_coins)+')'
            child = BiNode(str(count),current_name)
            father.children.append(child)
            count += 1

            if amount == 0:
                return 1
            elif (amount < 0) or (kinds_of_coins == 0):
                return 0
            else:
                new_amount = amount-self._first_denomination[kinds_of_coins-1]
                return  wrapper(amount, (kinds_of_coins - 1), child) + \
                        wrapper(new_amount, kinds_of_coins,child)
        id_ = '0'
        label = 'CountChange' + str(self.kinds_of_coins)
        self._root = BiNode(id_,label)
        return wrapper(self.amount,self.kinds_of_coins,self._root)
    
    @property
    def answer(self):
        return self._answer
    
    @property
    def root(self):
        return self._root

   
cc = CountChange(11)
nd = NodeDrawer(cc.root)
nd.draw()

