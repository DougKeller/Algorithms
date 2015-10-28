Douglas Keller
Readme

Huffman Coding Project 2

Running -
	To run, simply open 'main.html'. For best results, open it with Google Chrome

Overview -
	My program has two behaviors -
		1. Encoding/compressing a text file
		2. Opening a .hzip file to view it as a sequence of bits.

If 'Encode' is selected, you will also see a textarea come up where you can put in your own message without having to upload a file.

How the program works -
	
	Encode
		When the string bound to by the text area is changed or when a text file is uploaded by the user, the following chain of events occurs:
			1. $scope.compress is called
				a. The frequencies of each character are calculated
				b. An array of leaves is created, with each node being an item with a Value and Weight
				c. buildTree is called
				d. traverse() is called with the created tree
				e. encode() is called to encode the original string

			2. when buildTree is called
				a. Iterates through the given array until it is only 1 item long
				b. at each iteration, the array is sorted by weight and combines the lowest two nodes
					i. The node containing the two combined subnodes has the values: left, right, weight
					ii. 'weight' is the combined weights of the left and right trees

			3. when traverse is called
				a. It performs a post-order traversal on the given tree
				b. If a leaf is encountered, store the path it took to reach that leaf onto the leaf item
				c. add each node to the traversal string once it has recursively traverse the left and right trees

			4. when encode is called
				a. Using the codes created for each node of the huffman tree, it replaces every char in the original message with its respective Huffman code
				b. It adds 0's to the end of the string for a buffer, to insure a multiple of 8 bits
				c. It stores every 8 bits as a unicode variable on the strEncode string

	View Binary
		When a .hzip file is uploaded by the user, getBinary() is called.
		getBinary() simply loops through each char of the message, converting each unicode char to its binary equivalent
