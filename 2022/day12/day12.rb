if ARGV.empty?
  data = DATA.readlines(chomp: true)
else
  data = File.readlines(ARGV.first, chomp: true)
end

graph = data.map(&:chars)

distances = {}
queue = []
e = nil

heights = Array.new(graph.size) { Array.new(graph.first.size) }
graph.each_with_index do |row, x|
  row.each_with_index do |cell, y|
    if cell == 'S' || cell == 'a'
      heights[x][y] = 1
      queue << [x, y]
      distances[[x, y]] = 0
    elsif cell == 'E'
      heights[x][y] = 26
      e = [x, y]
    else
      heights[x][y] = cell.ord - 'a'.ord + 1
    end
  end
end

while queue.any?
  x, y = queue.shift
  distance = distances[[x, y]]

  [[-1, 0], [0, 1], [1, 0], [0, -1]].each do |dx, dy|
    nx, ny = x + dx, y + dy
    if nx.between?(0, graph.size - 1) &&
        ny.between?(0, graph.first.size - 1) &&
        heights[nx][ny] <= heights[x][y] + 1

      if distances[[nx, ny]].nil? || distances[[nx, ny]] > distance + 1
        distances[[nx, ny]] = distance + 1
        queue << [nx, ny]
      end
    end
  end
end

p distances[e]

__END__
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
