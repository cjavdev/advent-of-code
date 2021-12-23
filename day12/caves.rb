require 'set'

def build_graph(inputs)
  graph = Hash.new {|h, k| h[k] = Set.new}
  inputs.map {|i| i.split('-')}.each do |a, b|
    graph[a] << b
    graph[b] << a
  end
  graph
end

def duplicate_smalls?(path)
  lower = path.select {|n| n == n.downcase}
  lower.length != Set.new(lower).length
end

def find_all_paths(graph)
  paths = [['start']]

  valid_paths = []
  while !paths.empty?
    current_path = paths.pop
    if current_path.last == 'end'
      valid_paths << current_path.dup
      next
    end

    graph[current_path.last].each do |neighbor|
      next if neighbor == 'start'
      # Part 1:
      # if neighbor == neighbor.upcase || !current_path.include?(neighbor)
      # Part 2:
      if neighbor == neighbor.upcase || !duplicate_smalls?(current_path) || !current_path.include?(neighbor)
        paths << current_path + [neighbor]
      end
    end
  end
  valid_paths.each do |path|
    p path
  end
end


if __FILE__ == $0
  # graph = build_graph(File.readlines(ARGV.first).map(&:chomp))
  # p graph
  # puts find_all_paths(graph).length
end

g = build_graph([
  'start-A',
  'start-b',
  'A-c',
  'A-b',
  'b-d',
  'A-end',
  'b-end',
])
p g
#
p find_all_paths(g).length
