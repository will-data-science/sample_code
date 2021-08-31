'''
Game of Life!
'''

from board import Board

def main():
    '''
    TODO: Update with user inputs for size
    TODO: Update with graphics to show game
    '''
    # Create the initial board
    gameBoard = Board(10, 5)

    # Run first iteration
    gameBoard.boardDraw()

    userInput = ''

    while userInput != 'q':
        userInput = input('Pres enter to go to next generation or q to quit')

        if userInput == '':
            gameBoard.boardUpdate()
            gameBoard.boardDraw()

main()
