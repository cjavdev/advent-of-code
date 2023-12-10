require "set"
input = <<~INPUT
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
INPUT

data = input.each_line.map(&:chomp)
data = DATA.readlines.map(&:chomp)
grid = data.map(&:chars)

def find_start(grid)
  grid.each_with_index do |row, x|
    row.each_with_index do |cell, y|
      return [x, y] if cell == 'S'
    end
  end
end

s = find_start(grid)

COMP = {
  "J" => [[-1, 0], [0,-1]],
  "L" => [[-1, 0], [0, 1]],
  "F" => [[ 1, 0], [0, 1]],
  "7" => [[0, -1], [1, 0]],
  "|" => [[-1, 0], [1, 0]],
  "-" => [[0,  1], [0,-1]],
  "." => [],
  "S" => []
  #"S" => [[-1,0],[0,1],[1,0],[0,-1]]
}

def find_cn(grid, cell)
  x, y = cell
  pipe = grid[x][y]
  COMP[pipe].map do |(dx, dy)|
    [x + dx, y + dy]
  end
end

sx, sy = s
paths =  [[-1,0],[0,1],[1,0],[0,-1]].map do |(dx, dy)|
  [sx + dx, sy + dy]
end

valid = []
paths.each do |(x,y)|
  if find_cn(grid, [x,y]).include?(s)
    valid << [x,y]
  end
end

node = valid.first
pipe = [s, node].to_set

while node != valid.last
  neighs = find_cn(grid, node)
  count = 0
  neighs.each do |neigh|
    next if pipe.include?(neigh)
    pipe << neigh
    node = neigh
    count += 1
  end
end

just_path = Array.new(grid.size) { Array.new(grid[0].size, " ") }

grid.each_with_index do |row, x|
  row.each_with_index do |cell, y|
    if pipe.include?([x, y])
      just_path[x][y] = cell
    end
  end
end

inside_count = 0
just_path.each_with_index do |row, x|
  row.each_with_index do |cell, y|
    # Don't look at the path itself
    next if pipe.include?([x, y])

    # look to the right until we hit the edge of the board and count up the
    # number of times we touch a wall
    north_facing_count = 0
    south_facing_count = 0

    (y..row.size).each do |y2|
      if ["F", "|", "7", "S"].include?(just_path[x][y2])
        south_facing_count += 1
      end
      if ["J", "|", "L", "S"].include?(just_path[x][y2])
        north_facing_count += 1
      end
    end

    if [north_facing_count, south_facing_count].min.odd?
      inside_count += 1
    end
  end
end

puts "Inside count: #{inside_count}"
# puts "Inside spots: #{inside_spots}"

