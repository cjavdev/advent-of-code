require 'byebug'

class Piece
  attr_reader :positions, :kind

  ORDER = [
    :dash,
    :plus,
    :jay,
    :line,
    :square
  ]

  def self.order
    @order ||= ORDER.cycle
  end

  def self.generate(start)
    send(order.next, start)
  end

  def self.line(start)
    Piece.new([
      [0, 0], [1, 0], [2, 0], [3, 0]
    ], start, :line)
  end

  def self.dash(start)
    Piece.new([
      [0, 0], [0, 1], [0, 2], [0, 3]
    ], start, :dash)
  end

  def self.square(start)
    Piece.new([
      [0, 0], [0, 1], [1, 0], [1, 1]
    ], start, :square)
  end

  def self.plus(start)
    Piece.new([
      [0, 1], [1, 0], [1, 1], [1, 2], [2, 1]
    ], start, :plus)
  end

  def self.jay(start)
    Piece.new([
      [0, 0], [0, 1], [0, 2], [1, 2], [2, 2]
    ], start, :jay)
  end

  def initialize(positions, start, kind)
    @kind = kind
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
  attr_reader :grid, :current_piece, :instruction_number
  attr_accessor :rocks

  def initialize(instructions, rocks)
    @grid = Array.new(30) { Array.new(7, 0) }
    @pieces = []
    @instructions = instructions.cycle
    @rocks = rocks
    @seen = Set.new
  end

  def all_positions
    @pieces.map(&:positions).flatten(1)
  end

  def height
    if all_positions.any?
      all_positions.map(&:first).max + 1
    else
      0
    end
  end

  def spawn_piece
    @current_piece = Piece.generate([height + 3, 2])
    @falling = false
    if @seen.include?(key)
      throw :done
    else
      puts "Seen: #{@seen.size} / #{key}"
      @seen << key
    end
  end

  def tick
    # Grow the grid if necessary
    if height > @grid.length - 5
      @grid += Array.new(6) { Array.new(7, 0) }
    end

    spawn_piece if @current_piece.nil?

    if !@falling
      instruction = @instructions.next
      @instruction_number += 1
      @current_piece.send(instruction, all_positions)
      @falling = true
    else
      if !@current_piece.move_down(all_positions)
        lock_piece(@current_piece)
        @current_piece = nil
      end

      @falling = false
    end
  end

  def lock_piece(piece)
    @rocks -= 1
    @pieces << piece
    piece.positions.each do |pos|
      @grid[pos[0]][pos[1]] = 1
    end
  end

  def run
    while @rocks > 0
      tick
    end
    height
  end

  def recent_snapshot
    grid[-20..height].join
  end

  def key
    [current_piece.kind, instruction_number, recent_snapshot].join
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

# Part 1
# board = Board.new(instructions, 2022)
# puts "Expected 3068 actual #{board.run}"

# Part 2
board = Board.new(instructions, 2022)
seen = Set.new
while true
  board.tick
end
# board = Board.new(instructions, 20)
# board.run
# p board.recent_snapshot
