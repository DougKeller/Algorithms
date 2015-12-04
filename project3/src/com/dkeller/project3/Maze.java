package com.dkeller.project3;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Random;


public class Maze {
	private Node[][] nodes;
	private int size;
	
	public Maze(boolean[][] defaults) {
		this.size = defaults.length;
		this.nodes = new Node[size][size];
		
		for(int r = 0; r < nodes.length; r++) {
			for(int c = 0; c < nodes.length; c++) {
				nodes[r][c] = new Node(r, c, defaults[r][c]);
			}
		}
		
		setHeads();
	}
	
	public Maze(int size) {
		this.size = size;
		this.nodes = new Node[size][size];
		for(int r = 0; r < nodes.length; r++) {
			for(int c = 0; c < nodes.length; c++) {
				nodes[r][c] = new Node(r, c, false);
			}
		}
	}
	
	public Maze(int size, double probability) {
		this.size = size;
		this.nodes = new Node[size][size];
		
		Random rand = new Random();
		for(int r = 0; r < nodes.length; r++) {
			for(int c = 0; c < nodes.length; c++) {
				boolean open = rand.nextDouble() < probability;
				nodes[r][c] = new Node(r, c, open);
			}
		}
		
		setHeads();
	}
	
	public void openRandomNode() {
		ArrayList<Node> closed = closedNodes();
		Random rand = new Random();
		Node selected = closed.get(rand.nextInt(closed.size()));
		selected.open = true;
		setHeads();
	}
	
	public double percolationEstimate() {
		double totalNodes = Math.pow(size, 2);
		return (double) (totalNodes - closedNodes().size()) / totalNodes;
	}
	
	public boolean percolates() {
		Node[] firstRow = nodes[0];
		Node[] lastRow = nodes[nodes.length - 1];
		
		for(Node a : firstRow) {
			if(a.open) {
				for(Node b : lastRow) {
					if(b.open && nodesConnect(a, b))
						return true;
				}
			}
		}
		return false;
	}
	
	public ArrayList<Cluster> clusters() {
		ArrayList<Cluster> clusters = new ArrayList<Cluster>();
		for(Node[] row : nodes) {
			for(Node n : row) {
				if(n.open)
					Cluster.add(n, clusters);
			}
		}
		return clusters;
	}
	
	public void print() {
		for(Node[] row : nodes) {
			for(Node n : row) {
				System.out.print(n.open ? ' ' : 'X');
			}
			System.out.println();
		}
	}
	
	public int print(String path) {
		try {
			ArrayList<Cluster> clusters = clusters();
			PrintWriter writer = new PrintWriter(path + ".ppm");
			writer.println("P3");
			writer.println("# " + path + ".ppm");
			writer.println("" + size + " " + size);
			writer.println("256");
			for(Node[] row : nodes) {
				for(Node node: row) {
					if(!node.open)
						writer.print(" 0 0 0  ");
					else {
						Cluster c = node.cluster;
						if(c == null)
							writer.print(" 0 0 0  ");
						else
							writer.print(String.format(" %d %d %d  ", c.color.getRed(), c.color.getGreen(), c.color.getBlue()));
					}
				}
				writer.println();
			}
			writer.close();
			
			return clusters.size();
		} catch (Exception e) {
			System.out.println("Unable to save as " + path + ".ppm");
			return 0;
		}
	}
	
	private ArrayList<Node> closedNodes() {
		ArrayList<Node> closed = new ArrayList<Node>();
		for(Node[] row : nodes) {
			for(Node n : row) {
				if(!n.open)
					closed.add(n);
			}
		}
		return closed;
	}
	
	private void setHeads() {
		for(int r = 0; r < nodes.length; r++) {
			for(int c = 0; c < nodes.length; c++) {
				setHead(r, c);
			}
		}
	}
	
	private void setHead(int r, int c) {
		if(!nodes[r][c].open)
			return;
		
		boolean hasLeftNode = c > 0 && nodes[r][c - 1].open;
		boolean hasTopNode = r > 0 && nodes[r - 1][c].open;
		
		if(hasLeftNode && hasTopNode) {
			int leftRow = r, leftCol = c - 1;
			int topRow = r - 1, topCol = c;
			
			nodes[r][c].head = nodes[leftRow][leftCol];
			
			while(nodes[leftRow][leftCol].head != null) {
				Node left = nodes[leftRow][leftCol];
				leftRow = left.head.row;
				leftCol = left.head.col;
			}
			
			while(nodes[topRow][topCol].head != null) {
				Node top = nodes[topRow][topCol];
				topRow = top.head.row;
				topCol = top.head.col;
			}
			
			if(nodes[topRow][topCol] != nodes[leftRow][leftCol])
				nodes[topRow][topCol].head = nodes[leftRow][leftCol];
		} else if(hasLeftNode)
			nodes[r][c].head = nodes[r][c - 1];
		else if(hasTopNode)
			nodes[r][c].head = nodes[r - 1][c];
		else
			nodes[r][c].head = null;
	}
	
	private boolean nodesConnect(Node a, Node b) {
		int r1 = a.row, c1 = a.col;
		int r2 = b.row, c2 = b.col;
		
		while(nodes[r1][c1].head != null) {
			Node n = nodes[r1][c1];
			r1 = n.head.row;
			c1 = n.head.col;
		}
		
		while(nodes[r2][c2].head != null) {
			Node n = nodes[r2][c2];
			r2 = n.head.row;
			c2 = n.head.col;
		}

		return nodes[r1][c1] == nodes[r2][c2];
	}
}
