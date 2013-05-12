# === Exercise 2 ===
# Fibonacci with memoization
class Fib

	@@memo = {0 => 0, 1 => 1}

	def self.fib_rec(n)
		# if @@memo[n].nil?
		# 	@@memo[n] = fib_rec(n-1) + fib_rec(n-2)
		# end
		# @@memo[n]
		@@memo[n] ||= fib_rec(n-1) + fib_rec(n-2)
	end

end

puts Fib.fib_rec(10)

# Exercise 2b
# A bit more general implementation of a memoized algorithm...
module Memo
	@@memo = {}

	def memoize(method)
		alias_method "old_#{method}".to_sym, method
		define_method(method) do |*args|
			@@memo[args] ||= send("old_#{method}".to_sym, *args)
		end
	end
end

# Exercise 2c
# Improving again, using a closure instead of a global variable in the Memo module
module Memo
	def memoize(method)
		old_method = instance_method(method)
		memo = {}
		define_method(method) do |*args|
			memo[args] ||= old_method.bind(self).call(*args)
		end
	end	
end

class Fib
	extend Memo
	def fib_rec(n)
		return n if n < 2
		return fib_rec(n-1) + fib_rec(n-2)
	end
	memoize :fib_rec
end

f = Fib.new
puts Fib.fib_rec(10)


# === Exercise 3 ===
# Define a shorcut to declare new attribute, associated with 
# a code block checking some conditions on the attribute itself

class Class
	
	def attr_checked(attribute, &validation)
		define_method "#{attribute}=" do |value|
			raise "Invalid attribute" unless validation.call(value)
			instance_variable_set("@#{attribute}", value)
		end
		define_method "#{attribute}" do 
			instance_variable_get("@#{attribute}")
		end
	end

end

class Person
	attr_checked :age do |v|
		v >= 18
	end
end

p = Person.new
p.age = 18
puts p.age
p.age = 17 # raise an exception!
puts p.age

