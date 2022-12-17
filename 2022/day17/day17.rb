require 'byebug'

class Piece
  attr_reader :positions

  ORDER = [
    :dash,
    :plus,
    :jay,
    :line,
    :square
  ].cycle

  def self.generate(start)
    send(ORDER.next, start)
  end

  def self.line(start)
    Piece.new([
      [0, 0], [1, 0], [2, 0], [3, 0]
    ], start)
  end

  def self.dash(start)
    Piece.new([
      [0, 0], [0, 1], [0, 2], [0, 3]
    ], start)
  end

  def self.square(start)
    Piece.new([
      [0, 0], [0, 1], [1, 0], [1, 1]
    ], start)
  end

  def self.plus(start)
    Piece.new([
      [0, 1], [1, 0], [1, 1], [1, 2], [2, 1]
    ], start)
  end

  def self.jay(start)
    Piece.new([
      [0, 0], [0, 1], [0, 2], [1, 2], [2, 2]
    ], start)
  end

  def initialize(positions, start)
    @positions = positions.map do |pos|
      [pos[0] + start[0], pos[1] + start[1]]
    end
  end

  def resting?(board)
    positions.any? { |(x, _)| x == 0 } ||
      positions.any? do |pos|
        board.grid[pos[0] - 1][pos[1]] == 1
      end
  end

  def move_down(all_positions)
    return false if positions.any? { |(x, y)| all_positions.include?([x - 1, y]) }
    return false if positions.any? { |(x, y)| x - 1 < 0}
    @positions = positions.map do |pos|
      [pos[0] - 1, pos[1]]
    end
    true
  end

  def move_left(all_positions)
    return if positions.any? { |(x, y)| all_positions.include?([x, y - 1]) }
    return if positions.any? { |(x, y)| y - 1 < 0}
    @positions = positions.map do |pos|
      [pos[0], pos[1] - 1]
    end
  end

  def move_right(all_positions)
    return if positions.any? { |(x, y)| all_positions.include?([x, y + 1]) }
    return if positions.any? { |(x, y)| y + 1 > 6}
    @positions = positions.map do |pos|
      [pos[0], pos[1] + 1]
    end
  end
end

class Board
  attr_reader :grid, :current_piece
  attr_accessor :rocks

  def initialize(instructions, rocks)
    @grid = Array.new(4) { Array.new(7, 0) }
    @pieces = []
    @instructions = instructions.cycle
    @rocks = rocks
  end

  def all_positions
    @pieces.map(&:positions).flatten(1)
  end

  def top_row
    if all_positions.any?
      all_positions.map(&:first).max + 1
    else
      0
    end
  end

  def spawn_piece
    @current_piece = Piece.generate([top_row + 3, 2])
    @falling = false
  end

  def tick
    if top_row > @grid.length - 5
      @grid << Array.new(7, 0)
      @grid << Array.new(7, 0)
      @grid << Array.new(7, 0)
      @grid << Array.new(7, 0)
      @grid << Array.new(7, 0)
      @grid << Array.new(7, 0)
    end

    spawn_piece if @current_piece.nil?

    if !@falling
      instruction = @instructions.next
      @current_piece.send(instruction, all_positions)
      @falling = true
    else
      if @current_piece.move_down(all_positions)
        @falling = false
      else
        lock_piece(@current_piece)
        @current_piece = nil
        @falling = false
      end
    end
  end

  def lock_piece(piece)
    @rocks -= 1
    @pieces << piece
    piece.positions.each do |pos|
      @grid[pos[0]][pos[1]] = 1
    end
  end

  def to_s
    (grid.length - 1).downto(0).map do |i|
      (0..6).map do |j|
        if !@current_piece.nil? && @current_piece.positions.include?([i, j])
          '@'
        elsif grid[i][j] == 1
          '#'
        else
          '.'
        end
      end.join
    end.join("\n")
  end
end

if ARGV.empty?
  pattern = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
else
  pattern = File.read(ARGV[0]).chomp
end

instructions = pattern.chars.map do |c|
  c == '>' ? :move_right : :move_left
end

ins = (0..instructions.length).to_a.cycle
pieces = Piece::ORDER

seen = Set.new
(0..220).each do |x|
  cur = [ins.next, pieces.next]
  if seen.include?(cur)
    puts "#{[x, cur]} seen"
  else
    puts "#{[x, cur]} Havent"
  end
  seen << cur
end

rocks = seen.length
b = Board.new(instructions, rocks)
while b.rocks > 0
  b.tick
end

height = b.top_row
puts "height after #{rocks} rocks: #{height} units"

rock_height = height
num_rocks_increase = 207
rock_height_increase = height

target = 2022
intervals = target / num_rocks_increase - 1
puts "intervals: #{intervals}"
final_rocks = rocks + (intervals * num_rocks_increase)
final_height = rock_height + intervals * rock_height_increase

p "final rocks: #{final_rocks}, final height: #{final_height}"

# while b.top_row <= height
#   b.tick
# end
#
# puts "height after #{rocks + b.rocks.abs} rocks: #{b.top_row} units"
#
