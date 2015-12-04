package com.dkeller.project3;

import java.awt.Color;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Cluster {
	public Color color;
	private List<Node> nodes;
	
	public Cluster() {
		nodes = new ArrayList<Node>();
		
		Random rand = new Random();
		color = new Color(64 + rand.nextInt(192), 64 + rand.nextInt(192), 64 + rand.nextInt(192));
	}
	
	public static void add(Node n, List<Cluster> clusters) {
		Node root = n;
		while(root.head != null)
			root = root.head;
		
		for(Cluster cluster : clusters) {
			for(Node node : cluster.nodes) {
				if(root.row == node.row && root.col == node.col) {
					cluster.nodes.add(n);
					n.cluster = cluster;
					return;
				}
			}
		}
		
		Cluster cluster = new Cluster();
		cluster.nodes.add(root);
		cluster.nodes.add(n);
		clusters.add(cluster);
		root.cluster = cluster;
		n.cluster = cluster;
	}
}
