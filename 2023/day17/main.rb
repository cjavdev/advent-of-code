input = <<~INPUT
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
INPUT
input = <<~INPUT
1111
9991
9991
9991
INPUT

require 'set'

DIRS = [
  [0, 1],
  [1, 0],
  [0, -1],
  [-1, 0],
].freeze

def find(blocks, max_in_row)
  # Start at 0, 0 going either right or down
  # with a heat of 0
  states = []
  states << [0, 0, 0, 0, 1, 1] # heat, x, y, dx, dy, blocks_in_row
  states << [0, 0, 0, 1, 0, 1] #
  visited = Set.new

  while !states.empty?
    current = states.sort!.shift
    wo_heat = current[1..]
    if visited.include?(wo_heat)
      next
    end
    visited << wo_heat

    heat, x, y, dx, dy, blocks_in_row = current
    nx, ny = x + dx, y + dy

    # If we'd fall off the grid, go to the next state
    if nx < 0 || ny < 0 || nx >= blocks.length || ny >= blocks.first.length
      next
    end

    new_heat = heat + blocks[nx][ny]

    # If we're at the bottom right corner, return the new heat
    if nx == blocks.length - 1 && ny == blocks.first.length - 1
      return new_heat
    end

    # Go through all possible directions to find new states
    DIRS.each do |ddx, ddy|
      # don't go back to the same spot
      if [ddx + dx, ddy + dy] == [0, 0]
        next
      end

      if [ddx, ddy] == [dx, dy]
        new_blocks_in_row = blocks_in_row + 1
      else
        new_blocks_in_row = 1
      end

      if new_blocks_in_row > max_in_row
        next
      end

      states << [new_heat, nx, ny, ddx, ddy, new_blocks_in_row]
    end
  end
end

input = DATA.read
blocks = input.split("\n").map {|line| line.chars.map(&:to_i) }
p "Min heat loss: #{find(blocks, 3)}"
