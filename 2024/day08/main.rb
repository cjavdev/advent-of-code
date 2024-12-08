input = <<~INPUT
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
INPUT

input2 = <<~INPUT
..........
..........
..........
....a.....
........a.
.....a....
..........
..........
..........
..........
INPUT

input = File.open("2024/day08/input").read

rows = input.split("\n").map(&:chars)

frequencies = (rows.flatten - ["."]).uniq

def print_r(rows)
  rows.each do |row|
    puts row.join
  end
end

antenna_positions = Hash.new { |h, k| h[k] = [] }
antinode_positions = Hash.new { |h, k| h[k] = [] }

# Go through each of the frequencies and search from the frequency point out to
# find a second matching frequency.
frequencies.each do |frequency|
  rows.each_with_index do |row, i|
    row.each_with_index do |char, j|
      if char == frequency
        antenna_positions[frequency] << [i, j]
      end
    end
  end
end

p antenna_positions
print_r(rows)

# Iterate over all of the combinations of 2 antenna positions for a given frequency.

expects = [[1, 3], [7, 6]]
p expects

antenna_positions.each do |frequency, positions|
  positions.combination(2).each do |(i1, j1), (i2, j2)|
    # Until we go off the board, keep calculating points in either direction.

    # Calculate the vector between the two points
    di = i2 - i1
    dj = j2 - j1

    i3 = i1
    j3 = j1

    antinode_positions[frequency] << [i3, j3]

    until i3 < 0 || j3 < 0 || i3 >= rows.size || j3 >= rows[0].size
      # Add a new point before i1,j1 at the same distance
      i3 = i3 - di
      j3 = j3 - dj

      antinode_positions[frequency] << [i3, j3]
    end


    i4 = i2
    j4 = j2

    antinode_positions[frequency] << [i4, j4]

    until i4 < 0 || j4 < 0 || i4 >= rows.size || j4 >= rows[0].size
      i4 = i4 + di
      j4 = j4 + dj

      antinode_positions[frequency] << [i4, j4]
    end
  end
end

antinode_rows = rows.dup.map(&:dup)

all_positions = []

antinode_positions.each do |frequency, positions|
  positions.each do |(i, j)|
    next if i < 0 || j < 0 || i >= rows.size || j >= rows[0].size

    all_positions << [i, j]
    antinode_rows[i][j] = "#"
  end
end

print_r(antinode_rows)
p all_positions.uniq.size