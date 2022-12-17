require 'rspec'
require './day17'

RSpec.describe Piece do
  it 'moves a piece right' do
    piece = Piece.line([0, 3])
    piece.move_right([])
    expect(piece.positions).to eq([
      [0, 4],
      [1, 4],
      [2, 4],
      [3, 4],
    ])

    piece = Piece.line([0, 6])
    piece.move_right([])
    expect(piece.positions).to eq([
      [0, 6],
      [1, 6],
      [2, 6],
      [3, 6],
    ])
  end

  it 'moves a piece left' do
    piece = Piece.line([0, 3])
    piece.move_left([])
    expect(piece.positions).to eq([
      [0, 2],
      [1, 2],
      [2, 2],
      [3, 2]
    ])

    piece = Piece.line([0, 0])
    piece.move_left([])
    expect(piece.positions).to eq([
      [0, 0],
      [1, 0],
      [2, 0],
      [3, 0]
    ])
  end

  it 'moves a piece down' do
    piece = Piece.line([3, 3])
    piece.move_down([])
    expect(piece.positions).to eq([
      [2, 3],
      [3, 3],
      [4, 3],
      [5, 3]
    ])

    piece = Piece.line([0, 0])
    piece.move_down([])
    expect(piece.positions).to eq([
      [0, 0],
      [1, 0],
      [2, 0],
      [3, 0]
    ])
  end

  it 'creates a piece' do
    piece = Piece.line([0, 0])
    expect(piece).to be_a(Piece)
    expect(piece.positions).to eq([
      [0, 0],
      [1, 0],
      [2, 0],
      [3, 0]
    ])

    piece = Piece.line([1, 1])
    expect(piece).to be_a(Piece)
    expect(piece.positions).to eq([
      [1, 1],
      [2, 1],
      [3, 1],
      [4, 1]
    ])
  end

  it 'creates a dash' do
    piece = Piece.dash([0, 0])
    expect(piece).to be_a(Piece)
    expect(piece.positions).to eq([
      [0, 0],
      [0, 1],
      [0, 2],
      [0, 3]
    ])

    piece = Piece.dash([1, 1])
    expect(piece).to be_a(Piece)
    expect(piece.positions).to eq([
      [1, 1],
      [1, 2],
      [1, 3],
      [1, 4]
    ])
  end

  it 'creates a square' do
    piece = Piece.square([0, 0])
    expect(piece).to be_a(Piece)
    expect(piece.positions).to eq([
      [0, 0],
      [0, 1],
      [1, 0],
      [1, 1],
    ])

    piece = Piece.square([1, 1])
    expect(piece).to be_a(Piece)
    expect(piece.positions).to eq([
      [1, 1],
      [1, 2],
      [2, 1],
      [2, 2]
    ])
  end

  it 'creates a plus' do
    piece = Piece.plus([0, 0])
    expect(piece).to be_a(Piece)
    expect(piece.positions).to eq([
      [0, 1],
      [1, 0],
      [1, 1],
      [1, 2],
      [2, 1]
    ])

    piece = Piece.plus([1, 1])
    expect(piece).to be_a(Piece)
    expect(piece.positions).to eq([
      [1, 2],
      [2, 1],
      [2, 2],
      [2, 3],
      [3, 2]
    ])
  end

  it 'creates a jay' do
    piece = Piece.jay([0, 0])
    expect(piece).to be_a(Piece)
    expect(piece.positions).to eq([
      [0, 0],
      [0, 1],
      [0, 2],
      [1, 2],
      [2, 2]
    ])

    piece = Piece.jay([1, 1])
    expect(piece).to be_a(Piece)
    expect(piece.positions).to eq([
      [1, 1],
      [1, 2],
      [1, 3],
      [2, 3],
      [3, 3]
    ])
  end
end
