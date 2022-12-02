class HeightMap
  attr_reader :grid

  def initialize(grid)
    @grid = grid
  end

  def basin_values
    basin_values = []
    low_points.map do |p|
      basin_points(p).length
    end.sort.reverse.take(3).inject(:*)
  end

  def risk_level
    low_points.inject(0) do |risk, p|
      risk + self[*p] + 1
    end
  end

  def basin_points(point)
    points = [point]
    basin_points = []
    while !points.empty?
      current = points.pop
      basin_points << current if self[*current] < 9
      candidates = neighbors(current)
      candidates.each do |c|
        next if self[*c] == 9
        if !basin_points.include?(c) && !points.include?(c)
          points << c
        end
      end
    end
    basin_points
  end

  def low_points
    low_points = []
    @grid.each_with_index do |row, x|
      row.each_with_index do |col, y|
        low_points << [x, y] if low_point?([x, y])
      end
    end
    low_points
  end

  def low_point?(point)
    p = self[*point]
    neighbor_values(point).all? {_1 > p}
  end

  def neighbor_values(point)
    neighbors(point).map { self[*_1] }
  end

  def neighbors((x, y))
    [
      [x-1, y],
      [x+1, y],
      [x, y-1],
      [x, y+1],
    ].select do |x, y|
      x.between?(0, @grid.length - 1) &&
        y.between?(0, @grid[0].length - 1)
    end
  end

  def [](x, y)
    @grid[x][y]
  end
end

if __FILE__ == $0
  grid = File.readlines(ARGV.first).map(&:chomp).map {_1.chars.map(&:to_i)}
  map = HeightMap.new(grid)
  p map.basin_values
end
