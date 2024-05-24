#Kathryn Visnic

#input name for the game.
name = input("What is your name?")
#define instructions that will be printed at the beginning of the game
#This includes the premise of the game and the commands to play
def Instructions():
    print()
    print("Welcome, " + name + " to Relax and Catch!")
    print("Your relaxing evening has been interrupted by the sudden intrusion of a mouse!")
    print("In order to continue your night of relaxing you must vanquish the mouse!")
    print("Gather all 6 items you will need to trap the mouse!")
    print("Move commands: go south, go north, go east, go west")
    print("Add to Inventory: get 'item name'")

def move_to_rooms(current_room, direction):
    if direction in rooms[current_room]:
        current_room = rooms[current_room][direction]
    else:
        print("Invalid move. Try again")
    return current_room

def Main():
#create dictionary of the rooms in the game
#this includes the name of the rooms, the items in the rooms, and what direction leads to different rooms
    rooms = {
        'Living Room': {'south': 'Entrance Room', 'north': 'Dining Room', 'east': 'Stairs to the basement',
        'west': 'Bathroom', 'Item': 'No item in this room'},
        'Dining Room': {'east': 'Kitchen', 'south': 'Living Room', 'Item': 'wine'},
        'Kitchen': {'west': 'Dining Room', 'Item': 'peanut-butter'},
        'Stairs to the basement': {'north': 'Basement', 'west': 'Living Room', 'Item': 'gloves'},
        'Entrance Room': {'east': 'Garage', 'north': 'Living Room', 'Item': 'shoes'},
        'Basement': {'south': 'Stairs to the basement', 'Item': 'instructions'},
        'Garage': {'west': 'Entrance Room', 'Item': 'trap'},
        'Bathroom': {'east': 'Living Room', 'Item': 'Mouse'}  # baddie
    }
#directions that are allowed
    directions = ['north', 'south', 'east', 'west']
#current room is the starting rooms, which is the Living Room
    current_room = 'Living Room'
#Inventory for the game to the items. It starts out empty
    Inventory = []
#print the instructions
    Instructions()
#Gameplay
    while True:
#The bathroom is the ending room. The followins shows how the game ends
        if current_room == 'Bathroom':
#Win condition. If the inventory count is equal to six, you win!
            if len(Inventory) == 6:
                print('EEK! A MOUSE!')
                print('Congratulations! You have all items needed to trap the mouse safely!')
                print('Go ahead an have a relaxing evening!')
                print('Thank you for playing!')
                break
#Lose condition. If the inventory count is anything other then equal to six, you lose!
#This means you didn't gather all the items
            else:
                print('EEK! A MOUSE!')
                print('You have failed to gather all the items to trap the mouse safely!')
                print('No relaxing evening for you!')
                break
 # show the current location
        print()
#adding a line of '-' to help break up game text
        print('-' * 30)
        print('You are in the ' + current_room)
        print('Inventory:', Inventory)
        room_dict = rooms[current_room]
#referencing the room dictionary to show items
        if "Item" in room_dict:
            Item = room_dict["Item"]
            if Item not in Inventory:
                print("You see a", Item)

# get user input for moves
#make it lowercase so that any uppercase letters input can be used
#split the play_move so that we can reference each word
        play_move = input("What do you do? ").lower().split()
        print('-' * 30)
        print()
#movement
        if play_move[0] == 'go':
            if play_move[1] in directions:
                room_dict = rooms[current_room]
                if play_move[1] in room_dict:
                    current_room = room_dict[play_move[1]]
                else:
# trying to move in a direction where there is no room
#print an error message
                    print()
                    print('-' * 30)
                    print('You cannot go that way.')
                    print('Try a different direction.')
                    print('-' * 30)
                    print()
#If there is an invalid input for movement
            else:
                print()
                print('-' * 30)
                print("Invalid entry")
                print('-' * 30)
                print()

# In order to quit game
        elif play_move[0] in ['exit', 'quit']:
            print('Thanks for playing!')
            print('BYE!')
            break
#Add item to inventory
#need to add item to the inventory list
        elif play_move[0] == 'get':
            if play_move[1] == Item:
                Inventory.append(Item)
                print("You have collected " + Item + "!")
            else:
                print('Invalid command')

        # bad command
        else:
            print('Invalid input')


Main()