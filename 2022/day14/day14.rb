FACTOR = 500

def parse_lines(lines)
  lines
    .map {|line| line.split(" -> ") }
    .map {|line| line.map {|pt| pt.split(",").map(&:to_i) } }
    .map {|line| line.each_cons(2).to_a }
end

def boundaries(lines)
  r_min, r_max = lines.flat_map {|line| line.flat_map {|seg| seg.map(&:first) } }.minmax
  c_min, c_max = lines.flat_map {|line| line.flat_map {|seg| seg.map(&:last) } }.minmax
  [r_min - FACTOR, r_max + FACTOR, 0, c_max + 2]
end

def lines_to_grid(boundaries, lines)
  r_min, r_max, c_min, c_max = boundaries
  grid = Array.new(c_max + 1) { Array.new(r_max - r_min + 1, '.') }
  lines.each do |line|
    line.each do |seg|
      start, finish = seg.sort
      r_start, c_start = start
      r_finish, c_finish = finish
      (r_start..r_finish).each do |r|
        (c_start..c_finish).each do |c|
          grid[c - c_min][r - r_min] = "#"
        end
      end
    end
  end
  grid[-1] = Array.new(r_max - r_min + 1, '#')
  grid
end

def display(grid)
  puts "  #{(0..grid.first.size).to_a.join}"
  grid.each_with_index do |row, i|
    puts "#{i} #{row.join}"
  end
end

def pour_sand(boundaries, grid, entry)
  r_min, r_max, c_min, c_max = boundaries
  start_r, start_c = entry

  rest = false
  while !rest
    if !(start_c).between?(c_min, c_max)
      puts "done start_c: #{start_c} - c_min: #{c_min} #{(start_c - c_min)} not between #{[c_min, c_max]}"
    end
    if !(start_r).between?(r_min, r_max)
      throw :done
    end

    if grid[start_c + 1 - c_min][start_r - r_min] == "."
      start_c += 1
    elsif grid[start_c + 1 - c_min][start_r - r_min] == "#" || grid[start_c + 1 - c_min][start_r - r_min] == "o"
      if grid[start_c + 1 - c_min][start_r - 1 - r_min] == "."
        start_c += 1
        start_r -= 1
      elsif grid[start_c + 1 - c_min][start_r + 1 - r_min] == "."
        start_c += 1
        start_r += 1
      else
        rest = true
      end
    end
  end

  grid[start_c - c_min][start_r - r_min] = 'o'
  if [start_r, start_c] == entry
    throw :done
  end
end

if ARGV.empty?
  require 'rspec/autorun'

  RSpec.describe 'parse lines' do
    let(:input) do
      [
        "498,4 -> 498,6 -> 496,6",
        "503,4 -> 502,4 -> 502,9 -> 494,9"
      ]
    end

    it 'parses lines into tuples of points' do
      result = parse_lines(input)
      expect(result).to eq([
        [[[498, 4], [498, 6]], [[498, 6], [496, 6]]],
        [[[503, 4], [502, 4]], [[502, 4], [502, 9]], [[502, 9], [494, 9]]]
      ])
    end

    it 'works' do
      lines = parse_lines(input)
      bounds = boundaries(lines)
      grid = lines_to_grid(bounds, lines)

      count = 0
      catch :done do
        while true
          pour_sand(bounds, grid, [500, 0])
          count += 1
        end
      end

      p count + 1
    end
  end
else
  # part 2 30367
  input = File.readlines(ARGV.first, chomp: true)
  lines = parse_lines(input)
  bounds = boundaries(lines)
  grid = lines_to_grid(bounds, lines)
  count = 0
  catch :done do
    while true
      pour_sand(bounds, grid, [500, 0])
      count += 1
    end
  end
  display(grid)
end
