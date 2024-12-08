# search.py
# ---------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

import util

class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]
    
    
### ADDED NODE CLASS ###
class Node:
    def __init__(self, state, parent=None, action=None, cost=0):
        self.state = state
        self.parent = parent
        self.action = action
        self.cost = cost

    def solution(self):
        actions = []
        node = self
        while node.parent is not None:
            actions.append(node.action)
            node = node.parent
        actions.reverse()
        return actions

    def expand(self, problem):
        successors = []
        for successor, action, stepCost in problem.getSuccessors(self.state):
            next_node = Node(successor, self, action, self.cost + stepCost)
            successors.append(next_node)
        return successors
####
    
    
    
### Test this code in terminal with:
### python3 pacman.py -l tinyMaze -p SearchAgent -a fn=depthFirstSearch
### python3 pacman.py -l MediumMaze -p SearchAgent -a fn=depthFirstSearch
### python3 pacman.py -l bigMaze -p SearchAgent -a fn=depthFirstSearch
def depthFirstSearch(problem):
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print("Start:", problem.getStartState())
    print("Is the start a goal?", problem.isGoalState(problem.getStartState()))
    print("Start's successors:", problem.getSuccessors(problem.getStartState()))
    """
    "*** YOUR CODE HERE ***"
    frontier = util.Stack()
    start_node = Node(problem.getStartState())
    frontier.push(start_node)
    explored = set()
    expanded_nodes = 0  # To track expanded nodes

    while not frontier.isEmpty():
        node = frontier.pop()
        if problem.isGoalState(node.state):
            #NEW
            actions = node.solution()  #for counting
            path_cost = problem.getCostOfActions(actions)  # Path cost
            print(f"Expanded Nodes (DFS): {expanded_nodes}")
            print(f"Path Cost (DFS): {path_cost}")
            return actions
         #NEW
        if node.state not in explored:
            explored.add(node.state)  # Mark the state as explored
            expanded_nodes += 1  # Increment the number of expanded nodes
            
            #return node.solution()
        #explored.add(node.state)
            
    

        for child in node.expand(problem):
            if child.state not in explored:
                frontier.push(child)

    return []  # No solution was found

    util.raiseNotDefined()
    
    
### Test this code in terminal with:
### python3 pacman.py -l tinyMaze -p SearchAgent -a fn=breadthFirstSearch
### python3 pacman.py -l mediumMaze -p SearchAgent -a fn=breadthFirstSearch
### python3 pacman.py -l bigMaze -p SearchAgent -a fn=breadthFirstSearch
def breadthFirstSearch(problem):
    """Search the shallowest nodes in the search tree first."""
    "*** YOUR CODE HERE ***"
    frontier = util.Queue()
    start_node = Node(problem.getStartState())
    frontier.push(start_node)
    explored = set()
    expanded_nodes = 0  # To track number of expanded nodes

    while not frontier.isEmpty():
        node = frontier.pop()
        
        if problem.isGoalState(node.state):
            #NEW
            actions = node.solution()  # Get the sequence of actions
            path_cost = problem.getCostOfActions(actions)  # Calculate path cost
            print(f"Expanded Nodes (BFS): {expanded_nodes}")
            print(f"Path Cost (BFS): {path_cost}")
            return actions  # Return the sequence of actions to the goal

            #return node.solution()
        #explored.add(node.state)
        
        #NEW
        if node.state not in explored:
            explored.add(node.state)  # Mark the state as explored
            expanded_nodes += 1  # Increment the number of expanded nodes


        for child in node.expand(problem):
            if child.state not in explored and child not in frontier.list:
                frontier.push(child)

    return []  # No solution was found

    util.raiseNotDefined()



def uniformCostSearch(problem):
    """Search the node of least total cost first."""
    "*** YOUR CODE HERE ***"
    util.raiseNotDefined()

def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0


# Importing manhattanDistance so that it can be used as a heuristic
from util import manhattanDistance

# The manhattanHeuristic function
def manhattanHeuristic(state, problem):
    """
    state: The current position in the grid (x, y)
    problem: The search problem, which contains information about the goal
    """
    goal = problem.goal  # Assuming the problem object has a goal property
    return manhattanDistance(state, goal)

### Test this code in terminal with:
### python3 pacman.py -l tinyMaze -p SearchAgent -a fn=aStarSearch
### python3 pacman.py -l mediumMaze -p SearchAgent -a fn=aStarSearch
### python3 pacman.py -l bigMaze -p SearchAgent -a fn=aStarSearch

# I used the manhattanHeuristic in my A* search.
# The Manhattan heuristic estimates the cost to reach the goal by
# calculating the Manhattan distance between the current position and
# the goal. It sums the absolute differences in the x and y coordinates:
#    Manhattan Distance = |x1 - x2| + |y1 - y2|
# This is effective in grid-based problems like Pacman, since it provides an
# optimistic estimate without accounting for obstacles.
def aStarSearch(problem, heuristic=manhattanHeuristic): # Changed the null heuristic
    """Search the node that has the lowest combined cost and heuristic first."""
    "*** YOUR CODE HERE ***"
    frontier = util.PriorityQueue()  # Using PriorityQueue for A*
    start_state = problem.getStartState()
    start_node = Node(start_state)
    
    frontier.push(start_node, 0)  # Initial state with priority 0 (f(n) = g(n) + h(n))
    explored = set()
    
    #NEW
    expanded_nodes = 0  # The counter to track number of expanded nodes

    while not frontier.isEmpty():
        node = frontier.pop()

        if problem.isGoalState(node.state):
            #return node.solution()
            #NEW
            actions = node.solution()  # Get the sequence of actions to reach the goal
            path_cost = problem.getCostOfActions(actions)  # Calculate the path cost
            print(f"Expanded Nodes (A*): {expanded_nodes}")
            print(f"Path Cost (A*): {path_cost}")
            return actions  # Return the actions that form the solution


        if node.state not in explored:
            explored.add(node.state)
            #NEW
            expanded_nodes += 1  # Increment the expanded nodes counter

            for child in node.expand(problem):
                if child.state not in explored:
                    g = child.cost  # g(n): The path cost to reach the node
                    h = heuristic(child.state, problem)  # h(n): Heuristic estimate to goal
                    f = g + h  # f(n) = g(n) + h(n)
                    frontier.push(child, f)

    return []  # No solution found
    util.raiseNotDefined()


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch
