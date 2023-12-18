require 'set'

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
# input = DATA.read
ins = input.split("\n").map(&:split)

DIRS = {
  "U" => [-1, 0],
  "D" => [1, 0],
  "L" => [0, -1],
  "R" => [0, 1]
}

DIRS2 = {
  "3" => [-1, 0],
  "1" => [1, 0],
  "2" => [0, -1],
  "0" => [0, 1]
}

ins = ins.map do |dir, steps, color|
  [DIRS[dir], steps.to_i, color]
end

ins = ins.map do |dir, steps, color|
  co = color.gsub("(", "").gsub(")", "").gsub("#", "")
  cs = co[0...5].to_i(16)
  dir2 = co[5]
  # [DIRS[dir], steps.to_i, color]#
  [DIRS2[dir2], cs]
end
# p ins
pos = [0, 0]

wall = [pos]

ins.each do |(dx, dy), s|
  s.times do
    pos = pos[0] + dx, pos[1] + dy
    wall << pos.dup
  end
end

p wall.length
wall
  .each_cons(2)
  .sum do |(x1, y1), (x2,y2)|
    x1 * y2 - x2 * y1
  end
    .abs
    .fdiv(2) => a

p (a - wall.length/2) + wall.length
