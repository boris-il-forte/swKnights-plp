require "./Geometry"

if __FILE__ == $PROGRAM_NAME
	puts "prova"
  a = Geometry::Point.new(1,2,3)
  b = Geometry::Point.new(2,2,3)
  c = Geometry::Point.new(1,1,3)
  p = Geometry::Plane.new(a,b,c)
  puts a.to_s
  puts b.to_s
  puts (a + b).to_s
  puts (a - b).to_s
  puts (-a).to_s
  puts p.to_s
end