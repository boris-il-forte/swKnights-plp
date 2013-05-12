# === Exercise 1 ===
# Extend the Range class with the + operation
module Math
	def self.min(n1, n2)
		n1 < n2 ? n1 : n2
	end

	def self.max(n1, n2)
		n1 > n2 ? n1 : n2
	end
end

class Range

	def +(other)
		new_min = Math::min(self.min, other.min)
		new_max = Math::max(self.max, other.max)
		Range.new(new_min, new_max)
	end

end

a = (1..10) + (10..20)
puts a
