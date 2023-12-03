require 'set'
input = <<~IN
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
IN
puts input
rows = input.each_line.map(&:chomp)
rows = DATA.readlines.map(&:chomp)
parts = []
syms = []
gearsym = []
rows.each_with_index do |row, x|
  row.chars.each_with_index do |char, y|
    next if char == "."
    next if char =~ /\d/
    syms << [x, y] if char == "*"

   # p [char, x, y]
  end
end
rat=[]
seen = Set.new
hits = []
#p syms
puts "--"
syms.each do |(x, y)|
 # p "checking #{x}, #{y}"
  [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1],
    [-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1]
  ].each do |dx, dy|
    c = rows[x + dx] && rows[x + dx][y + dy]
    if c =~ /\d/
      hits << [x + dx, y + dy]
    end
  end

  part_starts = Set.new
  hits.each do |(x, y)|
    next if seen.include? [x, y]
    seen << [x, y]
    c = rows[x][y]
    #puts "before"
    #p [c, x, y]
    while rows[x][y-1] =~ /\d/
      #p rows[x][y-1]
      y -= 1
    end
    #p [rows[x][y], x, y]
    part_starts << [x, y]
  end
  if part_starts.length == 2
    rat << part_starts.map do |(x, y)|
      rows[x][y..].to_i
    end.inject(:*)
  end
end
p rat
p rat.sum
