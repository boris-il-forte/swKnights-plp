require "./Math"

module Geometry
	#Point, described by three coordinates
	class Point
		attr_accessor :x,:y,:z
		def initialize x, y, z
			@x, @y, @z = x, y, z
		end

		def to_s
			"(#{@x},#{@y},#{@z})"
		end

		def to_a
			[@x, @y, @z]
		end

		def -@
			Point.new(-@x,-@y,-@z)
		end

		def +(other)
			Point.new(@x + other.x, @y + other.y, @z + other.z)
		end

		def -(other)
			-other + self
		end

		def *(n)
			Point.new(@x * n, @y * n, @z * n)
		end

	end

	#Segment, described as two points
	class Segment
		attr_reader :a, :b
		def initialize(a,b)
			if a.x < b.x
				@a, @b = a, b
			else
				@a, @b = b, a
			end
		end

		def a=(new)
			if new < b.x
				@a = new
			else
				@a, @b = b, new
			end
		end

		def b=(new)
			if new > a.x
				@b = new
			else
				@a, @b = new, a
			end
		end

		def belongs(point)
			
			#uses the parametric form of the line of the segment to check  the property
			u1 = (point.x - a.x) / (b.x - a.x)
			u2 = (point.y - a.y) / (b.y - a.y)
			u3 = (point.z - a.z) / (b.z - a.z)
			
			u1 == u2 && u2 == u3 && u1 > 0 && u1 < 1
		end

		def intersection(segment)
			#the extremes of the firs segment
			a, b = @a, @b
			
			#the extremes of the second segment
			aa, bb = segment.a, segment.b

			#the linear system that solves the intersection of the two lines (in parametric form)
			bVector = [aa.x - a.x, aa.y - a.y, aa.z - a.z]
			aMatrix = [[aa.x - bb.x, b.x - a.x], [aa.y - bb.y, b.y - a.y], [aa.z - bb.z, b.z - a.z]]
			system = Math::LinearSystem.new(aMatrix, bVector)
			r = system.solve

			#the coefficents parameters
			v = r[0]
			u = r[1]

			raise "No intersection" if u<0 || u>1 || v<0 || v>1

			#the coordinates of the intersection (using the parametric form ;P)
			x = a.x + u*(b.x - a.x)
			y = a.y + u*(b.y - a.y)
			z = a.z + u*(b.z - a.z)

			Point.new(x,y,z);
		end

	end

	#Plane, described by the equation ax + by + cz +d = 0
	class Plane
		def initialize(a, b, c, d)
			@a, @b, @c, @d = a, b, c, d
		end

		def initialize(p1, p2, p3)
			@d = -1
			system = Math::LinearSystem.new([p1.to_a, p2.to_a, p3.to_a], [@d, @d, @d])
			r = system.solve
			puts "il sistema risolto vale:#{r}"
			@a, @b, @c = r[0], r[1], r[2]
		end

		def belongs(point)
			@a * point.x + @b * point.y + @c * point.z + d == 0
		end

		#TODO rifinire! fa schifissimo!
		def to_s
			"#{@a}x + #{@b}y + #{@c}z + #{@d} = 0"
		end

	end

	#Line, described as intersection of two planes
	class Line
		def initialize(p1, p2)
			@p1, @p2 = p1, p2
		end

		def belongs(point)
			p1.belong(point) && p2.belong(point)
		end

		#TODO! intersezione tra due rette, rette parallele...

	end

end
