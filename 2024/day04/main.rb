require "byebug"
input = <<~INPUT
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
INPUT

input = File.open("2024/day04/input").read

rows = input.split("\n").map(&:chars)

# Find all the X's since those are always the start of the word, then grow in all directions to see if it's XMAS
def xmas?(rows, x, y)
  found = 0
  found += 1 if xmas_dir?(rows, x, y, -1, -1)
  found += 1 if xmas_dir?(rows, x, y, -1, 0)
  found += 1 if xmas_dir?(rows, x, y, -1, 1)
  found += 1 if xmas_dir?(rows, x, y, 0, -1)
  found += 1 if xmas_dir?(rows, x, y, 0, 1)
  found += 1 if xmas_dir?(rows, x, y, 1, -1)
  found += 1 if xmas_dir?(rows, x, y, 1, 0)
  found += 1 if xmas_dir?(rows, x, y, 1, 1)
  found
end

def xmas_dir?(rows, x, y, dx, dy)
  word = ""
  4.times do |i|
    new_x = x + dx * i
    new_y = y + dy * i
    word << rows[new_x][new_y] if new_x >= 0 && new_y >= 0 && rows[new_x] && rows[new_x][new_y]
  end
  word == "XMAS"
end

def xmas2?(rows, x, y)
  # x,y is the coords of the A in MAS
  coords = []
  coords << [x, y] if xmas2_dir?(rows, x, y)
  coords
end

def xmas2_dir?(rows, x, y) #, dx, dy)
  return false if x < 1 || y < 1 || x + 2 > rows.length || y + 2 > rows[0].length
  [rows[x - 1][y - 1], rows[x + 1][y + 1]].compact.sort == ["M", "S"] &&
    [rows[x - 1][y + 1], rows[x + 1][y - 1]].compact.sort == ["M", "S"]
end

found = []
rows.each_with_index do |row, x|
  row.each_with_index do |char, y|
    if char == "A"
      # Grow in all directions to see if it's XMAS
      found += xmas2?(rows, x, y)
    end
  end
end
p found.count
p found.uniq.count