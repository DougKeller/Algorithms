Douglas Keller
Project 1

README

This program has 6 behaviors, depending on the number of arguments given:

0:

	The program will prompt the user for a message to encrypt.
	Outputs:
	  - A pair of public/secret keys capable of encrypting the given message
	  - The result of encrypting the message with the public key
	  - The result of decrypting the encrypted message with the secret key

1:

	For argument n, outputs a prime number n digits long.
	  e.g.
		>rsa.exe 10
	  ## Outputs
		1912997173

2:

	For arguments a and b, outputs two digits x and y such that ax + by = gcd(a, b)
	  e.g.
		>rsa.exe 5 12
	  ## Outputs
		x = 5,  y = -2, gcd = 1

3:

	For arguments e, p, and q: Outputs (d, n) such that ed = 1 % (p - 1)(q - 1)
	  e.g.
		>rsa.exe 17 37 43
	  ## Outputs
		d = 89, n = 1591

4:

	For arguments 'e', e, n, message: Outputs message in its encrypted form, given a public key (e, n)
	  e.g.
		>rsa.exe 'e' 487 3551 A
	  ## Outputs
		709

	For arguments 'd', d, n, message: Outputs the result of decrypting message with a secret key (d, n)
	  e.g.
		>rsa.exe 'd' 895 3551 709
	  ## Outputs
		A

====================================
Explanation on implemented methods
rsa.rb


I made sure to make the behavior of everything within my program explicit and intuitive with minimal explanation, so most of the 

implemented methods don't have anything notable worth mentioning.

The only notable thing I can think of is the 'ext_euclidean' method vs the 'mod_inverse' method.
ext_euclidean returns a hash containing the x, y, and gcd found through the Extended Euclidean algorithm. mod_inverse is 

essentially the same thing, albeit slightly more simplified. Since we don't need all three variables, it only returns the number 

needed in calculating 'd' for a secret key.

A nice feature of Ruby is that all classes are open, meaning you can go into existing classes and add new behavior with ease. I 

did this with the String#from_ascii_int and #to_ascii_int methods. In these methods, I'm essentially converting from/to base 128. 

However, since I'm only displaying the encrypted message as a base 10 string rather than a base 128 string, this isn't a true 

base conversion - hence the odd names.
