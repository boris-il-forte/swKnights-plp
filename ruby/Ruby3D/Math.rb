require "matrix"

module Math
	#linear system
	class LinearSystem
		def initialize(a, b)
			@A = Matrix.rows(a)
			@b = Matrix.row_vector(b)	
		end

		def solve
			x = @b * @A.inverse
			x.row(0)
		end
	end

end