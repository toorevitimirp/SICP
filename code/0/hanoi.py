class Rod(object):
    def __init__(self,name, disks):
        self.name = name
        self.disks = disks


def solution0(n):
    __steps__ = 0
    __a__ = Rod('a',[n-i for i in range(n)])
    __b__ = Rod('b',[])
    __c__ = Rod('c',[])

    def move(rod1,rod2):
        from_, to = legal(rod1, rod2)
        disk_to_move = from_.disks.pop()
        to.disks.append(disk_to_move)
        nonlocal __steps__
        __steps__ += 1 
        print("{}:{}->{}".format(disk_to_move,from_.name,to.name))
    def legal(rod1, rod2):
        rod1_disks = rod1.disks
        rod2_disks = rod2.disks
        if len(rod1_disks)==0:
            from_ = rod2
            to = rod1
        elif len(rod2_disks)==0:
            from_ = rod1
            to = rod2
        elif rod1_disks[-1] > rod2_disks[-1]:
            from_ = rod2
            to = rod1
        else:
            from_ = rod1
            to = rod2
        return from_, to
    
    def iter():
        while len(__c__.disks) != n:
            if n % 2 == 0:
                try:
                    move(__a__,__b__)
                    move(__a__,__c__)
                    move(__b__,__c__)
                except:
                    pass
            else:
                try:
                    move(__a__,__c__)
                    move(__a__,__b__)
                    move(__b__,__c__)
                except:
                    pass

        print("done!")
        print("steps:{}".format(__steps__))
    iter()


def solution1(n):

    __steps__ = 0
    __a__ = Rod('a',[n-i for i in range(n)])
    __b__ = Rod('b',[])
    __c__ = Rod('c',[])
    hand = __a__

    def get_from():
        nonlocal hand

        candidates_from = []
        for candidate in [__a__,__b__,__c__]:
            if candidate != hand:
                candidates_from.append(candidate)
        
        can_from_0 = candidates_from[0]
        can_from_1 = candidates_from[1]

        if len(can_from_0.disks) == 0:
            from_ =can_from_1
        elif len(can_from_1.disks) == 0:
            from_ = can_from_0
        else:
            if can_from_0.disks[-1] < can_from_1.disks[-1]:
                from_ = can_from_0

            else:
                from_ = can_from_1
        return from_

    def get_to(from_):
        candidates_to = []
        for candidate in [__a__,__b__,__c__]:
            if candidate != from_:
                candidates_to.append(candidate)
        
        can_to_0 = candidates_to[0]
        can_to_1 = candidates_to[1]
        if len(can_to_0.disks) == 0:
            top_subtraction = can_to_1.disks[-1] - from_.disks[-1]
            if top_subtraction < 0:
                to = can_to_0
            elif top_subtraction %2 == 0:
                to = can_to_0 
            else:
                to = can_to_1
        elif len(can_to_1.disks) == 0:
            top_subtraction = can_to_0.disks[-1] - from_.disks[-1]
            if top_subtraction < 0:
                to = can_to_1
            elif top_subtraction % 2 == 0:
                to = can_to_1
            else:
                to = can_to_0
        else:
            top_subtraction = can_to_0.disks[-1] - from_.disks[-1]
            if top_subtraction<0:
                to = can_to_1
            else:
                top_subtraction = can_to_1.disks[-1] - from_.disks[-1]
                if top_subtraction < 0:
                    to = can_to_0
                else:
                    if top_subtraction % 2 == 1:
                        to = can_to_1
                    else:
                        to = can_to_0
        return to

    def move(from_,to):
        disk_to_move = from_.disks.pop()
        to.disks.append(disk_to_move)

        nonlocal __steps__
        nonlocal hand
        hand = to
        __steps__ += 1 
        print("{}:{}->{}".format(disk_to_move,from_.name,to.name))
    
    if n%2==1:
        move(__a__,__c__)
        hand = __c__
    else:
        move(__a__,__b__)
        hand = __b__

    while len(__c__.disks)<n:
        from_ = get_from()
        to = get_to(from_)
        move(from_, to)
    print("done!")
    print("steps:{}".format(__steps__))
