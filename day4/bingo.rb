class Board
  attr_reader :rows, :columns

  def initialize(rows)
    @rows = rows
    @columns = @rows.transpose
  end

  def call_number(number)
    rows.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        if cell == number
          self[row_index, column_index] = 'X'
        end
      end
    end
  end

  def score
    rows.flatten.reject{_1 == 'X'}.inject(:+)
  end

  def to_s
    rows.map { |row| row.join(' ') }.join("\n")
  end

  def []=(row, column, value)
    rows[row][column] = value
    columns[column][row] = value
  end

  def bingo?
    rows.any? { |row| row.all? { |mark| mark == 'X' } } ||
    columns.any? { |column| column.all? { |mark| mark == 'X' } }
  end
end

class Bingo
  attr_reader :boards, :numbers
  attr_reader :won_board, :winning_number, :lost_board, :losing_number

  def initialize(boards, numbers)
    @boards = boards
    @numbers = numbers
  end

  def play
    @won_board = nil
    @winning_number = nil
    @lost_board = nil
    @losing_number = nil

    puts "Playing Bingo"
    numbers.each do |number|
      puts "Calling #{number}"
      call_number(number)

      if @won_board.nil? && !winning_board.nil?
        puts "We have a winner!"
        puts "The winning board is:"
        puts winning_board
        @won_board = winning_board
        @winning_number = number
      end

      if losing_boards.length == 1
        @lost_board = losing_boards.first
      end

      if losing_boards.length == 0
        @losing_number = number
        break
      end
    end
  end

  def display
    boards.each do |board|
      puts board
    end
  end

  def losing_boards
    boards.select { |board| !board.bingo? }
  end

  def winning_board
    boards.each do |board|
      return board if board.bingo?
    end
    nil
  end

  def call_number(number)
    boards.each do |board|
      board.call_number(number)
    end
  end
end

if __FILE__ == $0
  numbers = nil
  number_string, *lines = File.readlines(ARGV.first)
  numbers = number_string.split(',').map(&:to_i)

  boards = []
  rows = []
  lines.each do |line|
    next if line.chomp.empty?
    rows << line.split(" ").map(&:to_i)

    if rows.size == 5
      boards << Board.new(rows)
      rows = []
    end
  end

  p boards
  bingo = Bingo.new(boards, numbers)
  bingo.play
  puts "Losing score: #{bingo.lost_board.score * bingo.losing_number}"


    # .each_with_index do |line, i|
    # if  i == 0
    #   numbers = line.split(',').map(&:to_i)
    # end
    # p numbers
    #
    # p line.chomp.split(/\S/)
    #
    # bingo = Bingo.new(
    #   line.chomp.split(',').map { |board| Board.new(board) },
    #   (1..100).to_a
    # )
    # bingo.play
  # end
end
