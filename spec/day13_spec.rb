require_relative '../day13/paper.rb'

RSpec.describe Paper do
  let(:paper) do
    input = <<~INP
    6,3
    0,4
    2,3

    fold along y=5
    fold along x=4
    INP
    Paper.parse(input)
  end

  let(:example_paper) do
    input = <<~INP
      6,10
      0,14
      9,10
      0,3
      10,4
      4,11
      6,0
      6,12
      4,1
      0,13
      10,12
      3,4
      3,0
      8,4
      1,10
      2,14
      8,10
      9,0

      fold along y=7
      fold along x=5
    INP
    Paper.parse(input)
  end

  it 'prints the resulting square' do
    example_paper.step
    expect(example_paper.to_s).to eq(<<~RES)
    #.##..#..#.
    #...#......
    ......#...#
    #...#......
    .#.#..#.###
    ...........
    ...........
    RES
    example_paper.step
    expect(example_paper.to_s).to eq(<<~RES)
    #####
    #...#
    #...#
    #...#
    #####
    .....
    .....
    RES
  end

  it 'folds left as expected' do
    paper.fold_left(2)
    expect(paper.grid).to eq([
      [1, 0],
      [0, 0],
      [0, 1],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 1],
    ])
  end

  it 'folds up as expected' do
    paper.fold_up(3)
    expect(paper.grid).to eq([
      [0, 0, 0, 1, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 1, 0],
    ])
  end

  it 'is marked as expected' do
    expect(paper.coordinates).to eq([
      [6, 3],
      [0, 4],
      [2, 3]
    ])
    expect(paper.folds).to eq([
      [0, 5],
      [4, 0],
    ])
    expect(paper.grid).to eq([
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 1, 0],
    ])
  end
end
