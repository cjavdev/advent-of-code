require '../day4/bingo.rb'
require 'byebug'


RSpec.describe Bingo do
  describe 'play' do
    it 'marks boards' do
      a = Board.new([
        [1, 2, 3, 4, 5],
        [6, 7, 8, 9, 10],
        [11, 12, 13, 14, 15],
        [16, 17, 18, 19, 20],
        [21, 22, 23, 24, 25]
      ])

      bingo = Bingo.new([a], [1, 2, 3, 4, 5])
      bingo.play
      expect(a).to be_bingo
    end
  end

  describe 'numbers' do
    it 'should find the winning board' do
      a = Board.new([
        ['X', nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, 'X', nil, nil],
        [nil, nil, nil, nil, nil]
      ])
      b = Board.new([
        ['X', nil, nil, nil, nil],
        ['X', nil, nil, nil, nil],
        ['X', nil, nil, nil, nil],
        ['X', nil, nil, nil, nil],
        ['X', nil, nil, nil, nil]
      ])
      c = Board.new([
        ['X', nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil]
      ])
      bingo = Bingo.new([a, b, c], [1, 2])
      expect(bingo.winning_board).to eq(b)
    end
  end
end

RSpec.describe Board do
  describe '#bingo?' do
    it 'should return true if a column on the board is marked' do
      board = Board.new(
        [
          ['X', nil, nil, nil, nil],
          ['X', nil, nil, nil, nil],
          ['X', nil, nil, nil, nil],
          ['X', nil, nil, nil, nil],
          ['X', nil, nil, nil, nil]
        ]
      )
      expect(board).to be_bingo
    end

    it 'should return true if a row on the board is marked' do
      board = Board.new(
        [
          ['X', 'X', 'X', 'X', 'X'],
          [nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil]
        ]
      )
      expect(board).to be_bingo
    end

    it 'should calculate score' do
      board = Board.new(
        [
          ['X', 'X', 'X', 'X', 'X'],
          ['X', 'X', 'X', 'X', 1],
          ['X', 'X', 'X', 'X', 2],
          ['X', 'X', 'X', 'X', 3],
          ['X', 'X', 'X', 'X', 4]
        ]
      )
      expect(board.score).to eq(10)
    end
  end
end
