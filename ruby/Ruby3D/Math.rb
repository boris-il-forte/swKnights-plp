require "matrix"

module Math
	#linear system
	class LinearSystem
		def initialize(a, b)
			@A = Matrix.rows(a)
			@b = Matrix.column_vector(b)	
		end

		def solve
			x = @A.inverse * @b
			x.column(0)
		end
	end

end