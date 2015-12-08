Doug Keller
Duan - Algorithms
Project 4 Readme

Extra Credit:

	Handling both .ppm and .pgm formats
	Generating an energy image of an image
	Generating cumulative vertical/horizontal energy images of the file
	Drawing the lowest-energy vertical/horizontal seam on the image
	
General use:

	Every command for the program starts with 'dkeller_4.exe <filepath>'
	This loads the image at <filepath> to perform operations on
	
	The program has different behaviors depending on the subsequent arguments given.
	Each option saves a new image in a folder named 'output'
	
	Options are:
		<v_amt> <h_amt>
			Carves v_amt vertical seams and h_amt horizontal seams from the image
			
			Usage:  $ dkeller_4.exe fox.ppm 100 150
			Output: fox_processed_100_150.ppm
			
		energy
			Creates a grayscale image of the energy values within the image
			
			Usage:  $ dkeller_4.exe fox.ppm energy
			Output: fox_energy.pgm
			
		vgradient
			Creates a grayscale image of the cumulative energies in the vertical direction of the image
			
			Usage:  $ dkeller_4.exe fox.ppm vgradient
			Output: fox_vgradient.pgm
			
		hgradient
			Creates a grayscale image of the cumulative energies in the horizontal direction of the image
			
			Usage:  $ dkeller_4.exe fox.ppm hgradient
			Output: fox_hgradient.pgm
			
		vseam
			Draws the lowest-energy vertical seam in the image
			
			Usage:  $ dkeller_4.exe fox.ppm vseam
			Output: fox_vseam.ppm
			
		hseam
			Draws the lowest-energy horizontal seam in the image
			
			Usage:  $ dkeller_4.exe fox.ppm hseam
			Output: fox_hseam.ppm
			
Class breakdown

	There are 4 classes in this application.
	
	Image: Representation of the loaded/processed image.
		Stores its name and a 2d map of the RGB values at each pixel
		
	Pixel: An RGB color model.
		Handles subtraction between two pixels, which returns the sum of absolute differences of the components in each pixel
	Timer: Utility class, used for timing the runtime of each stage of the application.
	Progress: Utility class, used for showing the progress of the operation in the console
	
Notes

	All of the methods in the Image class are pretty straight-forward in my opinion, so I didn't include a description of each one.
	If you have any questions, please email me.
