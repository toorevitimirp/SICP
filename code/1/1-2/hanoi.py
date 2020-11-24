class Rod(object):
    def __init__(self, name, disks):
        self.name = name
        self.disks = disks

    @property
    def top(self):
        return self.disks[-1]

    @property
    def height(self):
        return len(self.disks)


def solution0(n):
    __steps__ = 0
    __a__ = Rod('a', [n - i for i in range(n)])
    __b__ = Rod('b', [])
    __c__ = Rod('c', [])

    def move(rod1, rod2):
        from_, to = legal(rod1, rod2)
        disk_to_move = from_.disks.pop()
        to.disks.append(disk_to_move)
        nonlocal __steps__
        __steps__ += 1
        print("{}:{}->{}".format(disk_to_move, from_.name, to.name))

    def legal(rod1, rod2):
        if rod1.height == 0:
            from_ = rod2
            to = rod1
        elif rod2.height == 0:
            from_ = rod1
            to = rod2
        elif rod1.top > rod2.top:
            from_ = rod2
            to = rod1
        else:
            from_ = rod1
            to = rod2
        return from_, to

    def iter_():
        while __c__.height != n:
            if n % 2 == 0:
                try:
                    move(__a__, __b__)
                    move(__a__, __c__)
                    move(__b__, __c__)
                except:
                    pass
            else:
                try:
                    move(__a__, __c__)
                    move(__a__, __b__)
                    move(__b__, __c__)
                except:
                    pass

        print("done!")
        print("steps:{}".format(__steps__))

    iter_()


def solution1(n):
    __steps__ = 0
    __a__ = Rod('a', [n - i for i in range(n)])
    __b__ = Rod('b', [])
    __c__ = Rod('c', [])
    hand = __a__

    def get_from():
        nonlocal hand
        candidates_from = []
        for candidate in [__a__, __b__, __c__]:
            if candidate != hand:
                candidates_from.append(candidate)
        can_from_0 = candidates_from[0]
        can_from_1 = candidates_from[1]

        if can_from_0.height == 0 or can_from_1.height == 0:
            if can_from_0.height == 0:
                from_ = can_from_1
            else:
                from_ = can_from_0
        else:
            if can_from_0.top < can_from_1.top:
                from_ = can_from_0
            else:
                from_ = can_from_1
        return from_

    def get_to(from_):

        def situation0(from_, zero, smaller_bigger):
            top_subtraction = smaller_bigger.top - from_.top
            if top_subtraction < 0 or \
                    top_subtraction % 2 == 0:
                to = zero
            else:
                to = smaller_bigger
            return to

        def situation1(from_,smaller,bigger):
            return bigger

        def situation2(from_, middle, bigger):
            top_subtraction = middle.top - from_.top
            if top_subtraction % 2 == 0:
                to = bigger
            else:
                to = middle
            return to

        candidates_to = []
        for candidate in [__a__, __b__, __c__]:
            if candidate != from_:
                candidates_to.append(candidate)

        can_to_0 = candidates_to[0]
        can_to_1 = candidates_to[1]
        if can_to_0.height == 0 or can_to_1.height == 0:
            if can_to_0.height == 0:
                to = situation0(from_, can_to_0, can_to_1)
            else:
                to = situation0(from_,can_to_1,can_to_0)
        else:
            if can_to_0.top < from_.top < can_to_1.top:
                to = situation1(from_,can_to_0,can_to_1)
            elif can_to_1.top < from_.top < can_to_0.top:
                to = situation1(from_, can_to_1, can_to_0)
            elif from_.top < can_to_1.top < can_to_0.top:
                to = situation2(from_, can_to_1, can_to_0)
            elif from_.top < can_to_0.top < can_to_1.top:
                to = situation2(from_, can_to_0, can_to_1)
            else:
                raise BaseException("situation does not exist！")
        return to

    def move(from_, to):
        disk_to_move = from_.disks.pop()
        to.disks.append(disk_to_move)

        nonlocal __steps__
        nonlocal hand
        hand = to
        __steps__ += 1
        print("{}:{}->{}".format(disk_to_move, from_.name, to.name))

    if n % 2 == 1:
        move(__a__, __c__)
        hand = __c__
    else:
        move(__a__, __b__)
        hand = __b__

    while __c__.height < n:
        from_ = get_from()
        to = get_to(from_)
        move(from_, to)
    print("done!")
    print("steps:{}".format(__steps__))


class HanoiBinary(object):
    def __init__(self, length, decimal=0):
        self.length = length
        self.bits = [0] * length
        for i in range(decimal):
            self.add_one()

    def __str__(self):
        res = ""
        for b in self.bits:
            res += str(b)
        return res

    @property
    def decimal(self):
        res = 0
        for i in range(self.length):
            res = res * 2 + self.bits[i]
        return res

    def add_one(self):
        carry = 1
        for i in range(self.length):
            index = self.length - i - 1
            sum_ = self.bits[index] + carry
            self.bits[index] = sum_ % 2
            carry = 1 if sum_ > 1 else 0
        return self

    def hanoi_status(self):
        from math import floor
        hanoi = {
            "A": [],
            "B": [],
            "C": []
        }
        n = self.length
        steps = self.decimal
        for i in range(n):
            disk = n - i
            gap = 2 ** (disk-1)
            move_times = floor((steps+gap)/(2*gap))
            dire = (disk+n) % 2
            if dire == 0:
                rods = ["A", "C", "B"]
            else:
                rods = ["A", "B", "C"]
            rod = rods[move_times % 3]
            hanoi[rod].append(disk)
        return hanoi


def solution2(n):

    __steps__ = 0
    __a__ = Rod('a', [n - i for i in range(n)])
    __b__ = Rod('b', [])
    __c__ = Rod('c', [])
    __bin__ = HanoiBinary(n)

    def move_which(current, next_ ):
        i = 0
        for i in range(n):
            if current[i] != next_[i]:
                break
        return n-i

    def direction(which_to_move, next_):
        index_diff = n - which_to_move
        zero_count = 0
        one_count = 0

        for i in range(index_diff):
            if next_[i] == 0:
                zero_count += 1
            else:
                one_count += 1

        return abs(zero_count - one_count) % 2

    def move():
        nonlocal __steps__
        __steps__ += 1
        current = [b for b in __bin__.bits]
        next_ = __bin__.add_one().bits
        which_to_move = move_which(current, next_)
        direc = "->" if direction(which_to_move, next_) \
                == 1 else "<-"
        print(which_to_move, ":", direc)
        # d = "->" if direc == 1 else "<-"

    for i in range(2**n-1):
        move()


def main():
    # step = 0
    # while step<16:
    #     # step = int(input(">>>"))
    #     hb = HanoiBinary(4, step)
    #     print(hb)
    #     print(hb.hanoi_status())
    #     step += 1
    solution1(4)


if __name__ == '__main__':
    main()
