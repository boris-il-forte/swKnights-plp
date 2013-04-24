require "./Geometry"

if __FILE__ == $PROGRAM_NAME
	puts "Test libreria Geometry"
	puts "Creo tre punti a, b, c"
  a = Geometry::Point.new(1,2,3)
  b = Geometry::Point.new(2,2,3)
  c = Geometry::Point.new(1,1,3)
  puts "a = #{a}"
  puts "b = #{b}"
  puts "c = #{c}"
  
  puts "a + b = #{a + b}"
  puts "a - b = #{a - b}"
  puts "- a  = #{-a}"
  puts "a * 4 = #{a*4}"
  
  puts "Creo un piano passante per a, b, c:"
  p = Geometry::Plane.new(a,b,c)
  puts "p = #{p}"
  puts "a appartiene a p? #{p.belongs(a)}"
  
  puts "Creo due segment: ab e de, d = (1.5,1,3) e = (1.5,3,3)"
  d = Geometry::Point.new(1.5,1,3)
  e = Geometry::Point.new(1.5,3,3)
  ab = Geometry::Segment.new(a,b)
  de = Geometry::Segment.new(d,e)
  x = ab.intersection(de)
  puts "l'intersezione vale x = #{x}"
  puts "x appartiene ad ab? e a? e b? #{ab.belongs(x)}, #{ab.belongs(a)}, #{ab.belongs(b)}"
  
end