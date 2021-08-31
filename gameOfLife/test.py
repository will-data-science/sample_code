from board import Board
from copy import deepcopy

def main():

    # Create the initial board

    allDead = Board(3, 3)
    allLive = Board(3, 3)

    [[x.statusUpdateDead() for x in row] for row in allDead.grid]
    [[x.statusUpdateLive() for x in row] for row in allLive.grid]

    # Test 1
    #
    # 000        000
    # 000   ->   000
    # 000        000
    #
    testBoard1 = deepcopy(allDead)
    testBoard1.boardUpdate()
    # assert testBoard1.grid == allDead.grid
    for row in range(len(testBoard1.grid)):
        for col in range(len(testBoard1.grid[row])):
            assert testBoard1.grid[row][col].getCellStatus() == "0"

    # Test 2
    #
    # 111       101
    # 111   ->  000
    # 111       101
    #
    testBoard2 = deepcopy(allLive)
    testBoard2.boardUpdate()

    correctUpdatedBoard2 = deepcopy(allDead)
    correctUpdatedBoard2.grid[0][0].statusUpdateLive()
    correctUpdatedBoard2.grid[0][2].statusUpdateLive()
    correctUpdatedBoard2.grid[2][0].statusUpdateLive()
    correctUpdatedBoard2.grid[2][2].statusUpdateLive()

    for row in range(len(testBoard2.grid)):
        for col in range(len(testBoard2.grid[row])):
            assert testBoard2.grid[row][col].getCellStatus() == correctUpdatedBoard2.grid[row][col].getCellStatus()

    # Test 3
    #
    # 010       010
    # 101   ->  101
    # 010       010
    #
    testBoard3 = deepcopy(allDead)
    testBoard3.grid[0][1].statusUpdateLive()
    testBoard3.grid[1][0].statusUpdateLive()
    testBoard3.grid[1][2].statusUpdateLive()
    testBoard3.grid[2][1].statusUpdateLive()

    correctUpdatedBoard3 = deepcopy(testBoard3)
    testBoard3.boardUpdate()

    for row in range(len(testBoard3.grid)):
        for col in range(len(testBoard3.grid[row])):
            assert testBoard3.grid[row][col].getCellStatus() == correctUpdatedBoard3.grid[row][col].getCellStatus()

    # Test 4
    #
    # 101       010
    # 010   ->  101
    # 101       010
    testBoard4 = deepcopy(allDead)
    testBoard4.grid[0][0].statusUpdateLive()
    testBoard4.grid[0][2].statusUpdateLive()
    testBoard4.grid[1][1].statusUpdateLive()
    testBoard4.grid[2][0].statusUpdateLive()
    testBoard4.grid[2][2].statusUpdateLive()

    correctUpdatedBoard4 = deepcopy(allDead)
    correctUpdatedBoard4.grid[0][1].statusUpdateLive()
    correctUpdatedBoard4.grid[1][0].statusUpdateLive()
    correctUpdatedBoard4.grid[1][2].statusUpdateLive()
    correctUpdatedBoard4.grid[2][1].statusUpdateLive()

    testBoard4.boardUpdate()

    for row in range(len(testBoard4.grid)):
        for col in range(len(testBoard4.grid[row])):
            assert testBoard4.grid[row][col].getCellStatus() == correctUpdatedBoard4.grid[row][col].getCellStatus()

    # Test 5
    #
    # 000        000
    # 000   ->   000
    # 000        000
    # 000        000

    testBoard5 = Board(4, 3)
    [[x.statusUpdateDead() for x in row] for row in testBoard5.grid]
    correctUpdatedBoard5 = deepcopy(testBoard5)
    testBoard5.boardUpdate()

    for row in range(len(testBoard5.grid)):
        for col in range(len(testBoard5.grid[row])):
            assert testBoard5.grid[row][col].getCellStatus() == correctUpdatedBoard5.grid[row][col].getCellStatus()

    # Test 6
    #
    # 0000        0000
    # 0000   ->   0000
    # 0000        0000

    testBoard6 = Board(3, 4)
    [[x.statusUpdateDead() for x in row] for row in testBoard6.grid]
    correctUpdatedBoard6 = deepcopy(testBoard6)
    testBoard6.boardUpdate()

    for row in range(len(testBoard6.grid)):
        for col in range(len(testBoard5.grid[row])):
            assert testBoard6.grid[row][col].getCellStatus() == correctUpdatedBoard6.grid[row][col].getCellStatus()

main()
