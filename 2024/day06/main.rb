require 'set'

input = <<~INPUT
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
INPUT

input = File.open("2024/day06/input").read
rows = input.split("\n").map(&:chars)

direction = [-1, 0]
og_location = nil
rows.each_with_index do |row, x|
  row.each_with_index do |cell, y|
    og_location = [x, y] if cell == "^"
  end
end

def print_rows(rows)
  puts
  rows.each do |row|
    puts row.join
  end
  puts
end

def step(rows, direction, location)
  x, y = location
  dx, dy = direction
  new_x = x + dx
  new_y = y + dy

  if new_x < 0 || new_x >= rows.length || new_y < 0 || new_y >= rows[0].length
    return
  end

  if rows[new_x][new_y] == "#"
    # Turn right
    direction[0] = dy
    direction[1] = -dx
    return [x, y]
  else
    rows[new_x][new_y] = "^"
    rows[x][y] = "X"
    return [new_x, new_y]
  end
end

def run(rows, og_direction, og_location, loop_detection = false)
  direction = og_direction.dup
  location = og_location.dup
  locations = Set.new([location.dup])
  location_directions = Set.new([*location.dup, *direction.dup])

  i = 0
  loop do
    location = step(rows, direction, location)

    break if location.nil?

    if loop_detection && location_directions.include?([*location.dup, *direction.dup])
      # p "Loop detected #{location.inspect} #{direction.inspect}"
      raise "Loop detected"
    end

    locations << location.dup
    location_directions << [*location.dup, *direction.dup]

    if rows.length < 100
      system("clear")
      print_rows(rows)
      sleep(0.1)
    end

    i += 1
  end

  # Part 1
  locations.uniq
end

locations = run(rows.dup.map(&:dup), direction, og_location)
p locations.length

# print_rows(rows)

# Go through all locations and try one by one to add a new obstruction in each of the locations to see if it
# causes a loop. If it does, we know that's a possible place to put a blocker.

loops = []

locations.each_with_index do |l, i|
  new_rows = rows.dup.map(&:dup)
  x, y = l

  new_rows[x][y] = "#"

  begin
    new_locations = run(new_rows, direction, og_location, true)
    # p new_locations.length
  rescue => e
    loops << [x, y]
  end

  if i % 100 == 0
    print "."
  end
end

puts

p loops
p loops.length
