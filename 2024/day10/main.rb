require 'byebug'
input = <<~INPUT
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
INPUT

input = File.open("2024/day10/input").read

heights = input
  .split("\n")
  .map(&:chars)
  .map {|l| l.map {|c| c == "." ? nil : c.to_i}}

trailheads = []
heights.each_with_index do |line, x|
  line.each_with_index do |height, y|
    if height == 0
      trailheads << [x, y]
    end
  end
end

def count_paths(heights, trailhead)
  seen = Set.new
  paths = {}
  valid = [trailhead]
  count = 0

  while valid.any?
    current = valid.pop
    paths[current] ||= {}
    path = paths[current]

    directions = [[0, -1], [0, 1], [-1, 0], [1, 0]]
    directions.each do |direction|
      new_position = [current[0] + direction[0], current[1] + direction[1]]

      next if new_position[0] < 0 || new_position[0] >= heights.length || new_position[1] < 0 || new_position[1] >= heights[0].length

      current_height = heights[current[0]][current[1]]
      new_height = heights[new_position[0]][new_position[1]]

      if new_height == current_height + 1
        valid << new_position
        if new_height == 9
          # Part 1, skip seen
          # if !seen.include?(new_position)
            count += 1
          # end

          # Part 1, skip seen
          # seen << new_position
        else
          path[new_position] ||= {}
        end
      end
    end
  end

  count
end

p trailheads.sum { count_paths(heights, _1) }
