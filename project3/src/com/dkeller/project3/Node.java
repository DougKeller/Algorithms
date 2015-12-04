package com.dkeller.project3;

public class Node {
	public int row, col;
	public boolean open;
	
	public Node head;
	public Cluster cluster;
	
	public Node(int row, int col, boolean open) {
		this.row = row;
		this.col = col;
		this.open = open;
	}
	
	public String toString() {
		return "(" + row + ", " + col + ")";
	}
}
