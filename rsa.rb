# Douglas Keller
# Algorithms - Duan - Fall 2015
# Project 1 - RSA Encryption

require 'openssl' # provides the mod_exp function

# Returns whether or not 'n' is prime
def prime?(n)
	return false unless n.odd? || n == 2
	(3..5).each do |a|
		break if a >= n
		return false if a.to_bn.mod_exp(n - 1, n) != 1
	end
	true
end

# Returns gcd, x, and y for gcd(a, b), such that ax + by = gcd(a, b)
def ext_euclidean(a, b)
	x, x_temp, y, y_temp = [1, 0, 0, 1]
	until b == 0
		quotient = a / b
		a, b = [b, a - quotient * b]
		x, x_temp = [x_temp, x - quotient * x_temp]
		y, y_temp = [y_temp, y - quotient * y_temp]
	end
	{ gcd: a, x: x, y: y }
end

# Returns t such that t is the a * t = 1 (mod n)
def mod_inverse(a, n)
	t, newt, r, newr = [0, 1, n, a]
	until newr == 0
		quotient = r / newr
		t, newt = [newt, t - quotient * newt]
		r, newr = [newr, r - quotient * newr]
	end
	throw :not_invertible if r > 1
	t += n if t < 0
	t
end

# Returns a prime number with n digits
def prime_number_with_length(n)
	loop do
		number = rand(10 ** (n - 1) .. 10 ** n - 1)
		return number if prime?(number)
	end
end

# Returns a number relatively prime to n
def number_coprime_to(n)
	loop do
		number = rand(2..(n - 1))
		return number if number.gcd(n) == 1
	end
end

class String
	# Converts a number n in base 128 to a string
	def self.from_ascii_int(n)
		str = ""
		while n > 0
			str = (n % 128).chr + str
			n /= 128
		end
		str
	end

	# Converts self to a number in base 128
	def to_ascii_int
		n = 0
		chars = split('').map(&:ord)
		chars.each_index { |i| n += chars[i] * 128 ** (chars.size - 1 - i) }
		n
	end
end

# Returns a pair of keys that's large enough to encrypt/decrypt 'message'
def generate_keys(message)
	size = ("#{message.to_ascii_int}".length / 2.0).ceil + 1
	p_val = prime_number_with_length(size)
	q_val = prime_number_with_length(size)
	n = p_val * q_val
	tn = (p_val - 1) * (q_val - 1)
	e = number_coprime_to(tn)
	d = mod_inverse(e, tn)

	generate_keys message if e == d
	[{ key: e, n: n }, { key: d, n: n }]
end

# Encrypts message^key % size
def encrypt(message, key, size)
	m = "#{message}".to_ascii_int
	throw :message_too_long if m >= size
	m.to_bn.mod_exp(key, size)
end

# Decrypts message^key % size
def decrypt(message, key, size)
	i = message.to_i.to_bn.mod_exp(key, size).to_i
	String.from_ascii_int(i)
end

case ARGV.size
when 0
	print "Enter a message to be encrypted: "
	message = gets.chomp
	keys = generate_keys(message)

	encrypted = encrypt(message, keys.first[:key], keys.first[:n])
	decrypted =  decrypt(encrypted, keys.last[:key], keys.last[:n])

	puts "Public Key: #{keys.first.inspect}\nSecret Key: #{keys.last.inspect}"
	puts "Encrypted: #{encrypted}\nDecrypted: #{decrypted}"
when 1
	# s: your program should output a prime with s digit to the console
	n = ARGV.first.to_i
	puts prime_number_with_length n
when 2
	# a b: your program should output (x,y) s.t. gcd(a,b) = ax+by and y>0
	a, b = ARGV.map(&:to_i)
	result = ext_euclidean(a, b)
	puts "x = #{result[:x]}, y = #{result[:y]}, gcd = #{result[:gcd]}"
when 3
	# e p q: your program should output (d,n) s.t. ed=1%(p-1)(q-1), n=pq
	e_val, p_val, q_val = ARGV.map(&:to_i)
	n = p_val * q_val
	on = (p_val - 1) * (q_val - 1)
	d = mod_inverse(e_val, on)
	puts "d = #{d}, n = #{n}"
else
	# ‘e’ e n message: your program should output the encrypted message
	# ‘d’ d n message: your program should output the decrypted message
	type = ARGV.first
	key, n = ARGV[1..2].map(&:to_i)
	message = ARGV[3..-1].join(' ')
	puts encrypt(message, key, n) if type.include? 'e'
	puts decrypt(message, key, n) if type.include? 'd'
end
