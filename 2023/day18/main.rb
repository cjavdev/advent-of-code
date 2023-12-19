input = <<~INPUT
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
INPUT


DIRS = {
  "R" => [0, 1],
  "L" => [0, -1],
  "U" => [-1, 0],
  "D" => [1, 0]
}

# 0 means R, 1 means D, 2 means L, and 3 means U.
DIRS2 = {
  "0" => [0, 1],
  "2" => [0, -1],
  "3" => [-1, 0],
  "1" => [1, 0]
}

# input = DATA.read
instructions = input.split("\n").map do |line|
  dir, steps, color = line.split(' ')
  color = color.gsub(/[()#]/, '')

  # PART 1
  # steps = steps.to_i
  # dir = DIRS[dir]

  # PART 2
  steps = color[0...5].to_i(16)
  dir = DIRS2[color[5]]

  [dir, steps]
end


# Array implementation which is too slow for part 2
# current = [0, 0]
# wall = []
#
# instructions.each do |dir, steps|
#   steps.times do
#     current = [current[0] + dir[0], current[1] + dir[1]]
#     wall << current
#   end
# end
#
# wall.each_cons(2).sum do |(x1, y1), (x2, y2)|
#   x1 * y2 - x2 * y1
# end.abs.fdiv(2) => area
# puts area


# Enumerator implementation which is fast enough for part 2
def gen(instructions, counter)
  current = [0, 0]
  Enumerator.new do |enum|
    instructions.each do |dir, steps|
      steps.times do
        counter.call
        current = [current[0] + dir[0], current[1] + dir[1]]
        enum << current
      end
    end
  end
end

wall_length = 0
gen(instructions, -> { wall_length += 1 })
  .each_cons(2) # shoelace formula
  .sum do |(x1, y1), (x2, y2)|
    x1 * y2 - x2 * y1
  end
    .abs
    .fdiv(2) => area

# Pick's theorem
# A = i + (b / 2) - 1
# I = A - (b / 2) + 1
interior_points = area - (wall_length / 2) + 1

# Add the boundary points back in with the wall points
puts interior_points + wall_length
