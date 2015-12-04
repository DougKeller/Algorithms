Douglas Keller
Duan - Algorithms
Project 3

Execution: Command Prompt
  Windows:
    $ run <args>
  Other:
    $ run.sh <args>
	Note: Running these scripts adds a flag to increase Java's stack size so that very large mazes can be handled (Game7.txt, etc)
	
Class Descriptions:

Project3:
  Handles cmd arguments
  
  # Arguments	Example 		Args			Result
	
  0				run				n/a				Prompts user for number of runs and maze size, and estimates a pecolation threshold.
  1				run game1.txt	filename	   	Outputs # Clusters, if the maze percolates, and generates a color-coded .ppm file
  2				run 0.5 Foo		P, name			Prompts the user for a size S, then generates a SxS name.ppm image with percolation probably P
  3				run 0.5 5 10	P, R, S			Generates a SxS maze R times with percolation P, then outputs the rate of percolation across all tests	
  
Node:
	Basic data structure used by Maze and Cluster classes.
	Stores a node's position and whether or not it is open
	Has a -head- node, and stores the cluster it is part of
	
Cluster:
	Wraps a list of Nodes and contains a -color- value that is used to generate .ppm images
	Generated when finding all the clusters within a Maze
	
Maze:
	Three constructors -
		2D array of boolean default values
		int S - makes a SxS maze with all nodes closed
		int S, double P - makes a SxS maze with all nodes open/closed based on P
			
	Functions:
		openRandomNode:			opens a closed node within the maze at random
		percolationEstimate:	returns the ratio of open nodes to total nodes within the Maze
		percolates:				returns whether or not a maze percolates from top to bottom
		clusters:				returns a generated List of all Clusters within the Maze
		print:					generates a .ppm image with the given name, or prints the maze to the terminal if no name is given
		
	Private:
		closedNodes:			returns a List of all closed Nodes within the Maze, used in percolationEstimate and openRandomNode
		setHeads:				calls setHead() for every node in the maze
		setHead:				looks at the nodes to the left and above the given node, and sets the head(s) according to the Union Find algorithm
		nodesConnect:			returns where or not two nodes branch from the same root node
		
