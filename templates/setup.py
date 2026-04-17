import sys


write = sys.stdout.write


def input():
    return sys.stdin.readline().strip()


def solve():
    pass


if __name__ == "__main__":
    t = int(input())
    for i in range(t):
        solve()
