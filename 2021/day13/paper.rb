require 'byebug'
class Paper
  def self.parse(input)
    numbers, folds = input.split("\n\n")
    numbers = numbers.split("\n").map {_1.split(",").map(&:to_i)}
    folds = folds.split("\n").map {_1.gsub(/fold along /, '').split('=')}.map do |var, pos|
      if var == 'x'
        [pos.to_i, 0]
      else
        [0, pos.to_i]
      end
    end
    Paper.new(numbers, folds)
  end

  attr_reader :coordinates, :folds, :grid

  def initialize(coordinates, folds)
    @coordinates = coordinates
    @folds = folds
    @grid = Array.new(max_coord.first) { Array.new(max_coord.last, 0) }
    coordinates.each {mark(_1)}
  end

  def fold_all
    while !@folds.empty?
      step
    end
  end

  def step
    fold = @folds.shift
    if fold.first == 0
      fold_left(fold.last)
      puts "fold left #{fold.last}"
    else
      fold_up(fold.first)
      puts "fold up #{ fold.first}"
    end
  end

  def mark((x, y))
    @grid[x][y] = 1
  end

  def fold_left(x)
    # If we're folding up...
    #   the y coordinate is the same
    #   the x coordinate is
    #     6 => 0
    #     5 => 1
    #     4 => 2
    #     3 => 3
    @grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        next if j < x
        if cell == 1
          @grid[i][j] = 0
          @grid[i][x - (j - x)] = 1
        end
      end
    end
    @grid = @grid.map.with_index do |row, i|
      row.select.with_index do |cell, j|
        j < x
      end
    end
  end

  def fold_up(y)
    # If we're folding up...
    #   the x coordinate is the same
    #   the y coordinate is
    #     6 => 0
    #     5 => 1
    #     4 => 2
    #     3 => 3
    @grid.each_with_index do |row, i|
      next if i < y
      row.each_with_index do |cell, j|
        if cell == 1
          @grid[i][j] = 0
          @grid[y - (i - y)][j] = 1
        end
      end
    end
    @grid = @grid.select.with_index do |_, i|
      i < y
    end
  end

  def max_coord
    x, y = 0, 0
    coordinates.each do |a, b|
      x = a if a > x
      y = b if b > y
    end
    [x + 1, y + 1]
  end

  def dots
    @grid.flatten.count(1)
  end

  def to_s
    (0...@grid.first.length).map do |i|
      (0...@grid.length).map do |j|
        @grid[j][i] == 1 ? '#' : ' '
      end.join
    end.join("\n") + "\n"
  end
end

if __FILE__ == $0
  paper = Paper.parse(File.read(ARGV.first))
  paper.fold_all
  puts paper
end
