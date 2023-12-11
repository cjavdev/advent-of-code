input = <<~INPUT
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
INPUT

data = input.each_line.map(&:chomp)
data = DATA.readlines.map(&:chomp)
grid = data.map(&:chars)

empty_rows = grid
  .filter_map
  .with_index do |row, i|
    if row.all? { |c| c == '.' }
      i
    end
  end

empty_cols = grid
  .transpose
  .filter_map
  .with_index do |row, i|
    if row.all? { |c| c == '.' }
      i
    end
  end

# Expanding universe attempt for part 1:
# empty_rows.reverse.each do |row|
#   grid.insert(row, Array.new(grid.first.size, '.'))
# end
# empty_cols.reverse.each do |col|
#   grid.each { |row| row.insert(col, '.') }
# end

galaxies = []
grid.each_with_index do |row, x|
  row.each_with_index do |col, y|
    if col == '#'
      galaxies << [x, y]
    end
  end
end

# p galaxies
def shortest_distance(a, b, grid, empty_rows, empty_cols)
  ax, ay = a
  bx, by = b
  d = (ax - bx).abs + (ay - by).abs
  ([ax, bx].min..[ax, bx].max).each do |x|
    if empty_rows.include?(x)
      # part 1
      # d += 1
      d += 1_000_000 - 1
    end
  end
  ([ay, by].min..[ay, by].max).each do |y|
    if empty_cols.include?(y)
      # part 1
      # d += 1
      d += 1_000_000 - 1
    end
  end
  d
end

pairs = galaxies
  .combination(2)
  .map { |a, b| [[a, b], shortest_distance(a, b, grid, empty_rows, empty_cols)] }
  .to_h

# pairs.each do |pair, dist|
#   #p [pair, dist]
# end
# grid.each do |row|
#   #puts row.join
# end

p pairs.length
p pairs.values.sum
