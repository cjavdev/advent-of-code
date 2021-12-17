require 'byebug'
require 'pqueue'
require 'set'

class Node
  attr_accessor :value, :distance_to_stop, :distance_to_start, :parent
  attr_reader :pos, :neighbors

  def initialize(pos, value)
    @pos = pos
    @neighbors = []
    @parent = nil
    @value = value

    # g
    @distance_to_start = 0
    # h
    @distance_to_stop = value
  end

  def heuristic_distance
    @distance_to_start + @distance_to_stop
  end

  def distance(n)
    x, y = pos
    nx, ny = n.pos
    (((x - nx) ** 2 + (y - ny) ** 2) ** 0.5) + value
  end

  def add_neighbor(n)
    @neighbors << n
  end
end

class Graph

  attr_reader :risk_levels

  def initialize(rl, size=1)
    @nodes = {}
    width = rl.length
    height = rl.first.length
    @risk_levels = Array.new(width) do
      Array.new(height * size, nil)
    end

    rl.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        # puts "Setting: #{ [i, j] } = #{cell}"
        @risk_levels[i][j] = cell

        (size - 1).times do |s|
          s += 1
          val = (cell + s)
          val %= 9 if val > 9
          # puts "Setting: #{ [i,j + (height * s)] } = #{val}"
          @risk_levels[i][j + (height * s)] = val
          # p @risk_levels
          # puts "Setting: #{ [i + (width * s), j] } = #{val}"
          # @risk_levels[i + (width * s)][j] = val

          # val2 = val + 1
          # val2 %= 9 if val2 > 9
          # puts "Setting: #{ [i + (width * s), j + (height * s)] } = #{val }"
          # # byebug
          # @risk_levels[i + (width * s)][j + (height * s)] = val2
        end
      end
    end
    new_rows = []
    (size - 1).times do |s|
      new_row = @risk_levels.map do |row|
        row.map do |cell|
          cell += s + 1
          cell %= 9 if cell > 9
          cell
        end
      end
      new_rows += new_row
    end
    @risk_levels += new_rows

    @risk_levels.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        pt = [i, j]
        @nodes[pt] = Node.new(pt, cell)
      end
    end

    @risk_levels.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        node = @nodes[[i, j]]
        neighbors([i, j]).each do |n|
          node.add_neighbor(@nodes[n])
        end
      end
    end
  end

  def start
    @nodes[[0, 0]]
  end

  def stop
    @nodes[[@risk_levels.length - 1, @risk_levels.first.length - 1]]
  end

  def reconstruct_path(node)
    return 0 if node.nil?
    return 0 if node == start
    puts "pos: #{node.pos}, v: #{node.value}"
    reconstruct_path(node.parent) + node.value
  end

  def calculate
    @open = Set.new([start])
    @closed = Set.new

    start.distance_to_start = 0
    start.distance_to_stop = start.distance(stop)

    while !@open.empty?
      current = open_min_distance
      if current == stop
        return reconstruct_path(current)
      end

      @open.delete(current)
      @closed << current

      current.neighbors.each do |n|
        next if @closed.include?(n)

        g_score = current.distance_to_start + current.distance(n)

        if !@open.include?(n)
          @open << n
          improving = true
        elsif g_score < n.distance_to_start
          improving = true
        else
          improving = false
        end

        if improving
          n.parent = current
          n.distance_to_start = g_score
          n.distance_to_stop = n.distance(stop)
        end
      end
    end
  end

  def open_min_distance
    @open.min {|a, b| a.heuristic_distance <=> b.heuristic_distance }
  end

  def neighbors((i, j))
    [
      [i - 1, j],
      [i + 1, j],
      [i, j + 1],
      [i, j - 1],
    ].select do |x, y|
      x.between?(0, @risk_levels.length - 1) &&
        y.between?(0, @risk_levels.first.length - 1)
    end
  end

  def to_s
    @risk_levels.map do |row|
      row.join
    end.join("\n")
  end
end

if __FILE__ == $0
  lines = File.readlines(ARGV.shift).map(&:chomp).map {_1.chars.map(&:to_i)}
  graph = Graph.new(lines, 5)
  puts graph
  p graph.calculate
end
