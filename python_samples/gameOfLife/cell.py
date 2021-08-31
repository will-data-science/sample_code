
class Cell:

    def __init__(self, row, col):
        '''
        Store initial status of a Cell
        Assume all cells start dead
        '''
        self.status = 0
        self.row = row
        self.col = col

    # Method to change status of cell to dead
    def statusUpdateDead(self):
        '''
        Update cell statusDead to be dead
        '''
        self.status = 0

    # Method to change status of cell to live
    def statusUpdateLive(self):
        '''
        Update cell status to be live
        '''
        self.status = 1

    # method to check if cell is currently alive
    def isAlive(self):
        '''
        Check if cell status is live
        '''
        if self.status == 1:
            return True
        return False

    # Method for what board should do

    def getCellStatus(self):
        if self.isAlive():
            return('1')
        return('0')
