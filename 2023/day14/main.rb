input = <<~INPUT
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
INPUT

def weight(grid)
  answer = 0
  grid.each_with_index do |row, i|
    answer += (grid.length - i) * row.count('O')
  end
  answer
end

def roll(row)
  swap = false
  (row.length - 1).times do |i|
    if row[i] == '.' && row[i + 1] == 'O'
      row[i], row[i+1] = row[i+1], row[i]
      swap = true
    end
  end
  swap ? roll(row) : row
end

def tilt(grid)
  grid.map { |row| roll(row.dup) }
end

def cycle(grid)
  e(s(w(n(grid.map(&:dup)))))
end

def n(grid)
  tilt(grid.transpose).transpose
end

def s(grid)
  tilt(grid.reverse.transpose).transpose.reverse
end

def e(grid)
  tilt(grid.map(&:reverse)).map(&:reverse)
end

def w(grid)
  tilt(grid)
end

grid = input.each_line.map(&:chomp).map(&:chars)
grid = DATA.readlines.map(&:chomp).map(&:chars)

pattern_counter = Hash.new{|h,k| h[k] = 0}
weights = {}
200.times do |n|
  grid = cycle(grid.map(&:dup))
  key = grid.join
  pattern_counter[key] += 1
  weights[n] = weight(grid)

  break if pattern_counter[key] > 2
end

offset = pattern_counter.values.count(1)
cycle_length = pattern_counter.values.count {_1 > 1}

puts "offset: #{offset}"
puts "cycle_length: #{cycle_length}"
run_cycles = 1000000000

index = (run_cycles - offset - 1) % cycle_length
puts "Answer #{weights[offset + index]}"


