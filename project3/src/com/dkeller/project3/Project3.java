package com.dkeller.project3;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Project3 {
	public static void main(String[] args) {
		switch(args.length) {
		case 1:
			runFromFile(args[0]);
			break;
		case 2:
			buildGame(args);
			break;
		case 3:
			runFromCommandLine(args);
			break;
		default:
			findThreshold();
			break;
		}
	}
	
	public static void runFromFile(String path) {
		boolean[][] defaults;
		try {
			List<String> strings = Files.readAllLines(Paths.get(path));
			defaults = new boolean[strings.size()][strings.size()];
			for(int r = 0; r < defaults.length; r++) {
				String line = strings.get(r).replaceAll(" ", "");
				for(int c = 0; c < defaults.length; c++) {
					char ch = line.charAt(c);
					defaults[r][c] = ch == '1';
				}
			}
		} catch (IOException e) {
			System.out.println("Unable to find " + path + ".");
			return;
		}
		
		Maze m = new Maze(defaults);
		
		String name = path.replace(".txt", "");
		System.out.println("Generating PPM file " + name + ".ppm ...");
		int clusters = m.print(name);
		
		System.out.println("Number of clusters: " + clusters);
		if(m.percolates())
			System.out.println("Percolates!");
		else
			System.out.println("Does not percolate.");
	}
	
	public static void buildGame(String[] args) {
		Scanner input = new Scanner(System.in);
		double p = Double.parseDouble(args[0]);
		System.out.print("Size of maze: ");
		int size = input.nextInt();
		input.close();
		String name = args[1];
		System.out.println("Generating a " + size + "x" + size + " ppm image named " + name + " with p=" + p + "...");
		Maze m = new Maze(size, p);
		m.print(name);
		System.out.println("Complete!");
		System.out.println("Checking if it percolates...");
		if(m.percolates())
			System.out.println("Percolates!");
		else
			System.out.println("Does not percolate.");
		
	}
	
	public static void runFromCommandLine(String[] args) {
		double p = Double.parseDouble(args[0]);
		int runs = Integer.parseInt(args[1]);
		int size = Integer.parseInt(args[2]);

		System.out.println("Percolation probability: " + p);
		System.out.println("         Number of runs: " + runs);
		System.out.println("              Maze size: " + size);
		
		int numPercolated = 0;
		
		for(int i = 0; i < runs; i++) {
			Maze m = new Maze(size, p);
			if(m.percolates())
				numPercolated++;
		}
		
		double rate = ((double) numPercolated) / runs;
		System.out.println("Number of  percolations: " + numPercolated);
		System.out.println("       Percolation rate: " + rate);
	}
	
	public static void findThreshold() {
		Scanner input = new Scanner(System.in);
		System.out.print("Number of runs: ");
		int runs = input.nextInt();
		System.out.print("     Maze size: ");
		int size = input.nextInt();
		input.close();
		
		ArrayList<Double> percs = new ArrayList<Double>();
		
		for(int i = 0; i < runs; i++) {
			Maze m = new Maze(size);
			
			while(!m.percolates())
				m.openRandomNode();
			
			percs.add(new Double(m.percolationEstimate()));
		}
		
		double sum = 0;
		for(Double d : percs)
			sum += d.doubleValue();
		
		double estimate = sum / runs;
		System.out.println("Percolation threshold: " + estimate);
	}
	
}
