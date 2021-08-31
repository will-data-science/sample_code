from cell import Cell
from random import randint
import itertools

class Board:

    def __init__(self, rows, columns):
        '''
        Set initial board based on columns & rows
        '''
        self.rows = rows
        self.columns = columns
        self.grid = [[Cell(rowCells, columnCells) for columnCells in range(self.columns)] for rowCells in range(self.rows)]

        self.boardGenerate()

    # Initially generate a game board
    def boardGenerate(self):
        for row in self.grid:
            for column in row:
                # Randomly generate live cells
                maxInt = 3 # Higher number -> less likely to be live
                if (randint(0, maxInt)) == 1:
                    column.statusUpdateLive()

    # Update board with next generation
    def boardUpdate(self):
        print('updating game board')

        # Store cells that will either go to live or to dead
        toLive = []
        toDead = []

        # Get number of live neighbors for each cell
        neighborsArray = [
            [
                self.getLiveNeighbors(self.getValidNeighbors(cell.row, cell.col)) for cell in row
            ] for row in self.grid]

        # Determine which live cells die
        toDead = list(itertools.chain(*[
            [
                cell for cell in row if (cell.status == 1 and not 2 <= neighborsArray[cell.row][cell.col] <= 3)
            ] for row in self.grid]))

        # Determine which dead cells live
        toLive = list(itertools.chain(*[
            [
                cell for cell in row if (cell.status == 0 and neighborsArray[cell.row][cell.col] == 3)
            ] for row in self.grid]))

        # Update the cells
        '''
        TODO: Determine if can remove for loop
        '''
        for cell in toLive:
            cell.statusUpdateLive()
        for cell in toDead:
            cell.statusUpdateDead()

    # Draw board
    def boardDraw(self):
        '''
        Draws the board in the terminal
        TODO: Update with graphics to replace terminal
        '''
        numRows = 4 # Controls boarder/line break in terminal
        print('\n' * numRows)
        print('printing board')
        for row in self.grid:
            for column in row:
                print(column.getCellStatus(), end = '') # use end to keep on same line
            print() # essentially creates a new line in terminal

    def getValidNeighbors(self, cellRow, cellColumn):
        '''
        Check if neighbors are valid (not outside board)
        Returns valid neighbors
        TODO: Clean up possibly remove for loops
        '''

        searchMin = -1 # minimum is 1 row/column before
        searchMax = 2 # maximum is 1 row/column after -> range will go to 2 - 1 = 1

        neighbors = []


        # check cells in rows/columns both before & after
        for row in range(searchMin, searchMax):
            for column in range(searchMin, searchMax):

                rowNeighbor = cellRow + row
                colNeighbor = cellColumn + column

                # By default assume a valid neighbor
                valid = True

                # Not valid if cell and neighbor have same indices
                if rowNeighbor == cellRow and colNeighbor == cellColumn:
                    valid = False

                # Not valid if neighbor is outside number of rows
                elif rowNeighbor < 0 or rowNeighbor >= self.rows:
                    valid = False

                # Not valid if neighbor is outside number of columns
                elif colNeighbor < 0 or colNeighbor >= self.columns:
                    valid = False

                if valid:
                    neighbors.append(self.grid[rowNeighbor][colNeighbor])

        return neighbors

    def getLiveNeighbors(self, allNeighbors) :
        return sum([x.status for x in allNeighbors])
