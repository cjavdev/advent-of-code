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
  def initialize(risk_levels)
    @nodes = {}
    @risk_levels = risk_levels
    risk_levels.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        @nodes[[i, j]] = Node.new([i, j], cell)
      end
    end
    risk_levels.each_with_index do |row, i|
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
      x.between?(0, risk_levels.length - 1) &&
        y.between?(0, risk_levels.first.length - 1)
    end
  end
end
# class Graph
#
#   attr_reader :risk_levels, :aggregate
#   def initialize(risk_levels)
#     @risk_levels = risk_levels
#     @aggregate = Array.new(risk_levels.length) do
#       Array.new(risk_levels.first.length, Float::INFINITY)
#     end
#     @aggregate[0][0] = 0
#     @risk_levels[0][0] = 0
#   end
#
#   def []((i, j))
#     @risk_levels[i][j]
#   end
#
#   def ag((i, j))
#     @aggregate[i][j]
#   end
#
#   def set_ag((i, j), v)
#     @aggregate[i][j] = v
#   end
#
#   def calculate
#     queue = PQueue.new([[[0, 0], 0]]) { |(coord, v), (coord2, v2)| v < v2 }
#     visited = Set.new
#
#     while !queue.empty?
#       # This needs to be pulling from a priority
#       # queue
#       current_location, current_value = queue.pop
#
#       neighbors(current_location).each do |n|
#         neighbor_value = self[n]
#         new_cost = current_value + neighbor_value
#         next if visited.include?(n)
#         visited << current_location
#         if new_cost < self.ag(n)
#           self.set_ag(n, new_cost)
#         end
#         queue.push([n, self.ag(n)])
#       end
#
#       # if queue.length % 100 == 0
#       #   puts "v: #{visited.length} q: #{queue.length}"
#       # end
#     end
#   end
#
#   def min_risk
#     @aggregate.flatten.last
#   end
#
#   def neighbors((i, j))
#     [
#       [i + 1, j],
#       [i, j + 1]
#     ].select do |x, y|
#       x.between?(0, risk_levels.length - 1) &&
#         y.between?(0, risk_levels.first.length - 1)
#     end
#   end
# end

if __FILE__ == $0
  lines = File.readlines(ARGV.shift).map(&:chomp).map {_1.chars.map(&:to_i)}
  graph = Graph.new(lines)
  p graph.calculate
end
