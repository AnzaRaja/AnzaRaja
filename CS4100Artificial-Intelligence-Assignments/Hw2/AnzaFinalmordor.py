import numpy as np
from tqdm import tqdm
import gymnasium as gym
import matplotlib.pyplot as plt
import json 
import matrix_mdp
import sys
import seaborn as sns


nS = 16
nA = 4

slip_prob = .1  # may want to test with different values

actions = ['up', 'down', 'left', 'right']  # Human readable labels for actions

p_0 = np.array([0 for _ in range(nS)])
p_0[12] = 1

P = np.zeros((nS,nS,nA), dtype=float)

def valid_neighbors(i,j):
    neighbors = {}
    if i>0:
        neighbors[0]=(i-1,j)
    if i<3:
        neighbors[1]=(i+1,j)
    if j>0:
        neighbors[2]=(i,j-1)
    if j<3:
        neighbors[3]=(i,j+1)
    return neighbors

for i in range(4):
    for j in range(4):
        if i==0 and j==2:
            continue            # outgoing probabilities from terminal states should be 0 in gymnasium
        if i==3 and j==1:
            continue            # outgoing probabilities from terminal states should be 0 in gymnasium

        neighbors = valid_neighbors(i,j)
        for a in range(nA):
            if a in neighbors:
                P[neighbors[a][0]*4+neighbors[a][1], i*4+j, a] = 1-slip_prob
                for b in neighbors:
                    if b != a:
                        P[neighbors[b][0]*4+neighbors[b][1], i*4+j, a] = slip_prob/float(len(neighbors.items())-1)

        
#################################################################
# REWARD MATRIX

# In this implementation, you only get the reward if you *intended* to get to 
# the target state with the corresponding action, but not through slipping.

# Doesn't really affect the implementation of your assignment questions below. 

#################################################################

R = np.zeros((nS, nS, nA))

R[2,1,3] = 2000
R[2,3,2] = 2000
R[2,6,0] = 2000

R[13,9,1] = 2
R[13,14,2] = 2
R[13,12,3] = 2

R[11,15,0] = -100
R[11,7,1] = -100
R[11,10,3] = -100
R[10,14,0] = -100
R[10,6,1] = -100
R[10,11,2] = -100
R[10,9,3] = -100
R[9,10,2] = -100
R[9,13,0] = -100
R[9,5,1] = -100
R[9,8,3] = -100

env=gym.make('matrix_mdp/MatrixMDP-v0', p_0=p_0, p=P, r=R)

#################################################################
# Helper Functions
#################################################################

#reverse map observations in 0-15 to (i,j)
def reverse_map(observation):
    return observation//4, observation%4

#################################################################
# Q-Learning
#################################################################

# STUDENTS TO IMPLEMENT THIS FUNCTION

'''

In this section, you will implement a function for Q-learning with epsilon-greedy exploration.
Refer to the written assignment for the update equation. Use the following code to take an action:

observation, reward, terminated, truncated, info = env.step(action)

Your action is now chosen by the epsilon-greedy policy. The action is chosen as follows:

With probability epsilon, choose a random legal action.
With probability (1 - epsilon), choose the action that maximizes the Q-value (based on the last estimate). 
In case of ties, choose the action with the smallest index.

In case the chosen action is not a legal move, generate a random legal action.

The episode terminates when the agent reaches one of two terminal states. 

The Q-table is initialized to all zeros. The learning rate will vary over time and for every (s,a) pair.
It should be initialized as 1 and each time Q(s, a) is updated, it should become 1/(1 + number of updates to Q(s,a)). 

The number of updates to Q(s,a) should be stored in a matrix of shape (nS, nA) initialized to zeros, 
and updated such that num_updates[s,a] gives you the number of times Q(s,a) has been updated.
You can then calculate eta using the formula above.

The value of epsilon should be decayed to (0.9999 * epsilon) at the end of each episode.

After 10, 500, and 10000 episodes, plot a heatmap of max Q(s, a) for all states s. Complete and use the plot_heatmaps() function. 
The heatmap should be a 4x4 grid, corresponding to our map of Mordor. Please use plt.savefig() to save the plot, and do not use plt.show().

'''


def q_learning(num_episodes, checkpoints, gamma=0.9, epsilon=0.9):
    """
    Q-learning algorithm.

    Parameters:
    - num_episodes (int): Number of Q-value episodes to perform.
    - checkpoints (list): List of episode numbers at which to record the optimal value function..

    Returns:
    - Q (numpy array): Q-values of shape (nS, nA) after all episodes.
    - optimal_policy (numpy array): Optimal policy, np array of shape (nS,), ordered by state index.
    - V_opt_checkpoint_values (list of numpy arrays): A list of optimal value function arrays at specified episode numbers.
      The saved values at each checkpoint should be of shape (nS,).
    """
    
    Q = np.zeros((nS, nA))
    num_updates = np.zeros((nS, nA))

    observation, info = env.reset()

    V_opt_checkpoint_values = []
    optimal_policy = np.zeros(nS)

    "YOUR CODE HERE"
    for episode in (range(num_episodes)):
        # Reset the environment for each episode
        observation, info = env.reset()  
        terminated = False
        
        while not terminated:
            # Get valid actions for the current state (i, j)
            i, j = reverse_map(observation)
            valid_actions = list(valid_neighbors(i, j).keys())

            # Epsilon-greedy action selection
            if np.random.rand() < epsilon:
                action = np.random.choice(valid_actions)  # Random valid action
            else:
                action = np.argmax(Q[observation]) # Best action based on Q-table
                

            # Take the action, observe reward and next state
            next_state, reward, terminated, truncated, info = env.step(action)

            # Ensure next_state is not None
            if next_state is None:
                print(f"Warning: Received None for state. Skipping update.")
                break

            # Ensure reward is not None
            if reward is None:
                reward = 0
            
            # For debugging
            # Print the current state, action, reward, and next state
            #print(f"State: {observation}, Action: {action}, Reward: {reward}, Next State: {next_state}")
            
            # Update learning rate alpha
            alpha = 1.0 / (1.0 + num_updates[observation, action])
            
            # Update the Q-value using the Q-learning update equation
            Q[observation, action] += alpha * (reward + gamma * np.max(Q[next_state]) - Q[observation, action])
            
            # Increment the update count for the state-action pair
            num_updates[observation, action] += 1
            
            # Move to the next state
            observation = next_state
        
        # Decay epsilon after each episode
        epsilon *= 0.999
        
        # Store checkpoint values
        if episode + 1 in checkpoints:
            V_opt = np.max(Q, axis=1)  # Optimal value for each state
            V_opt_checkpoint_values.append(V_opt)
    
    # Derive the optimal policy from the Q-table
    for s in range(nS):
        if s == 2 or s == 13:  # Terminal states
            optimal_policy[s] = -1
        else:
            optimal_policy[s] = np.argmax(Q[s])  # Best action for each state



    return Q, optimal_policy, V_opt_checkpoint_values





def plot_heatmaps(V_opt, filename):
    """
    Plots a 4x4 heatmap of the optimal value function, with state positions 
    corresponding to cells in the map of Mordor, with the given filename.

    Do not use plt.show().

    Parameters:
    V_opt (numpy array): A numpy array of shape (nS,) representing the optimal value function.
    filename (str): The filename to save the plot to. 

    Returns:
    None
    """



    "YOUR CODE HERE"
    # NOTE: I tried to plot my heatmaps using VSCode, however it was not allowing me to do so.
    # I had to use Google Colab to do it so I printed out the matrix values for all 3 heatmaps 
    # in my code below so that I could use those matrices in Google Colab.
    # This is what I did in Google Colab to plot the 3 heatmaps:
    #
    #   HEATMAP1
    ### import seaborn as sns
    ### import matplotlib.pyplot as plt
    ### import numpy as np
    ###
    ### update = [[   0., 2000.,    0.,    0.],
    ###  [   0.,    0.,    0.,    0.],
    ###  [   0.,    2.,    0.,    0.],
    ###  [   2.,    0. ,   0.,    0.]]
    ### 
    ### plt.figure(figsize=(6, 6))
    ### sns.heatmap(update, cmap="YlGnBu", cbar=True, square=True,
    ###         xticklabels=False, yticklabels=False)   
    ###
    #   HEATMAP2
    ### update = [[1723.66509987, 1957.25847159,    0.,         1977.47568633],
    ###  [1399.96867587, 1713.34096988, 1878.6843394,  1699.43630888],
    ###  [ 953.36221051, 1374.45678809, 1474.26564296, 1070.35173167],
    ###  [ 544.38685633,    0.,         1033.14885577,  690.34879243]]
    ### 
    ### plt.figure(figsize=(6, 6))
    ### sns.heatmap(update, cmap="YlGnBu", cbar=True, square=True,
    ###          xticklabels=False, yticklabels=False)  
    #   HEATMAP3
    ### update = [[1710.91109512, 1953.02784957,    0. ,        1977.99392368],
    ###  [1521.8195016,  1729.45852397, 1952.52142689, 1723.76985181],
    ###  [1202.3869488,  1477.93927676, 1658.00441907, 1351.46044994],
    ###  [ 936.93219575,    0.,         1083.62370109,  749.65844316]]
    ### plt.figure(figsize=(6, 6))
    ### sns.heatmap(update, cmap="YlGnBu", cbar=True, square=True,
    ###         xticklabels=False, yticklabels=False)   

    # Reshape V_opt into a 4x4 grid
    V_opt_grid = V_opt.reshape((4, 4))

    # To get the matrix values for all 3 heatmaps so that I could plot them
    print ("update", V_opt_grid)

    plt.figure(figsize=(6, 6))
    sns.heatmap(V_opt_grid, annot=True, cmap="YlGnBu", cbar=True, square=True,
                xticklabels=False, yticklabels=False)
    
    # Save the heatmap to the specified file
    plt.savefig(filename)
    plt.close()


    


'''
If you need to make changes below for debugging, please first note down the defaults specified below.
Your submission should include plots generated using these default values, and slip_prob=0.1 (set in line 13).
'''

def main(): 

    Q, optimal_policy, V_opt_checkpoint_values = q_learning(10000, checkpoints=[10, 500, 10000])
    #print(Q)
    #print(optimal_policy)
    plot_heatmaps(V_opt_checkpoint_values[0], "heatmap_10.png")
    plot_heatmaps(V_opt_checkpoint_values[1], "heatmap_500.png")
    plot_heatmaps(V_opt_checkpoint_values[2], "heatmap_10000.png")

    
    
if __name__ == "__main__":
    main()