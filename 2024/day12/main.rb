require 'byebug'
input = <<~INPUT
AAAA
BBCD
BBCC
EEEC
INPUT
input = <<~INPUT
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
INPUT

input = <<~INPUT
EEEEE
EXXXX
EEEEE
EXXXX
EEEEE
INPUT

inputx = File.open("2024/day12/input").read
plots = input.split("\n").map(&:chars)
directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]

to_visit = []

plots.each_with_index do |row, x|
  row.each_with_index do |crop, y|
    to_visit << [x, y, crop, 4]
  end
end

seen = {}
group_seen = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = {} } }
group = 0

to_visit.each do |square|
  x, y, crop, size = square
  next if seen[[x, y]]
  # seen[[x, y]] = 4

  g_seen = group_seen[crop][group]

  # If we haven't already seen this crop, we need to explore and grow out from it.
  queue = [square]
  while queue.any?
    x, y, crop, size = queue.shift

    next if g_seen[[x, y]]
    g_seen[[x, y]] = 4
    seen[[x, y]] = 4

    directions.each do |(dx, dy)|
      nx, ny = x + dx, y + dy
      next if nx < 0 || ny < 0 || nx >= plots.size || ny >= plots[0].size

      if plots[nx][ny] == crop
        queue << [nx, ny, crop, size]
        seen[[x, y]] -= 1
        g_seen[[x, y]] -= 1
      end
    end
  end

  group += 1
end

m = plots.dup.map(&:dup)

fences = []

group_seen.each do |crop, groups|
  groups.each do |group, seen|
    fences << [seen.count, seen.map { |(x, y), s| s }.sum]
    seen.each do |(x, y), size|
      m[x][y] = group
    end
  end
end

# m.each do |row|
#   puts row.join
# end

p fences.inject(0) { |sum, (area, perimeter)| sum + (area * perimeter) }
