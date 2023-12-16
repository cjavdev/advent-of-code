input = File.read("./example")
input = File.read("./input")

grid = input.split("\n").map(&:chars)

DIR = {
  right: [0, 1],
  left: [0, -1],
  up: [-1, 0],
  down: [1, 0]
}

TURN = {
  "/" => {
    right: :up,
    left: :down,
    up: :right,
    down: :left
  },
  "\\" => {
    right: :down,
    left: :up,
    up: :left,
    down: :right
  }
}

def energy(beam, grid)
  beams = [beam]
  seen = Set.new
  while !beams.empty?
    x, y, direction = beams.shift
    dx, dy = DIR[direction]
    if x + dx < 0 || x + dx >= grid.size || y + dy < 0 || y + dy >= grid[0].size
      next
    end
    new_beams = []
    front = grid[x + dx][y + dy]
    case [front, direction]
    in ["|", :right | :left]
      new_beams << [x + dx, y + dy, :up]
      new_beams << [x + dx, y + dy, :down]
    in ["-", :up | :down]
      new_beams << [x + dx, y + dy, :left]
      new_beams << [x + dx, y + dy, :right]
    in ["/" | "\\", _]
      new_beams << [x + dx, y + dy, TURN[front][direction]]
    in [_, _]
      new_beams << [x + dx, y + dy, direction]
    end

    new_beams.each do |beam|
      beams << beam if !seen.include?(beam)
    end
    seen += beams
  end
  seen.map { |x, y, _| [x, y] }.to_set.length
end

max = 0

(0...grid.size).each do |x|
  max = [energy([x, -1, :right], grid), max].max
  max = [energy([x, grid.first.length, :left], grid), max].max
  p max
end
(0...grid.first.size).each do |y|
  max = [energy([-1, y, :down], grid), max].max
  max = [energy([grid.length, y, :up], grid), max].max
  p max
end

# grid.each_with_index do |row, x|
#   row.each_with_index do |cell, y|
#     if energized.include?([x, y])
#       print "#"
#     else
#       print "."
#     end
#   end
#   print "\n"
# end
