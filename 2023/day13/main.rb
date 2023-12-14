require 'rspec/autorun'
input = <<~INPUT
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
INPUT

def around(line, index)
  left, right = line.partition.with_index { |c, idx| idx < index }
  len = [left.length, right.length].min
  left = left.reverse
  left[0...len] == right[0...len]
end

def points_of_symetry(line)
  (1...line.length).select { |i| around(line, i) }
end

def lines_of_symetry(pattern)
  pattern.map do |line|
    points_of_symetry(line)
  end.inject(&:&)
end

input = DATA.read
patterns = input
  .split("\n\n")
  .map { |pattern| pattern.split("\n").map(&:chars) }

answer = 0
answer2 = 0
patterns.each do |pattern|
  puts "\n\n---------------"
  sym_rows = lines_of_symetry(pattern.transpose).first
  sym_cols = lines_of_symetry(pattern).first
  answer += (sym_rows.to_i * 100) + sym_cols.to_i

  p "Rows: #{sym_rows}"
  p "Cols: #{sym_cols}"
  sub_rows = Set.new
  sub_cols = Set.new
  pattern.each_with_index do |row, row_idx|
    row.each_with_index do |col, col_idx|
      # At row_idx, col_idx, swap from "#" => "." or "." => "#"
      sub_pattern = pattern.map(&:dup)
      sub_pattern[row_idx][col_idx] = col == "#" ? "." : "#"

      sub_rows += lines_of_symetry(sub_pattern.transpose)
      sub_cols += lines_of_symetry(sub_pattern)
    end
  end

  sub_rows -= [sym_rows]
  sub_cols -= [sym_cols]
  p "Sub Rows: #{sub_rows}"
  p "Sub Cols: #{sub_cols}"
  answer2 += (sub_rows.first.to_i * 100) + sub_cols.first.to_i
end

puts "Part 1 answer: #{answer}"
puts "Part 2 answer: #{answer2}"
