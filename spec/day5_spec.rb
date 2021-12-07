require '../day5/vents.rb'

RSpec.describe OceanFloor do
  it 'parses lines as expected' do
    lines = [
      '1,2 -> 3,4',
      '3,4 -> 4,5',
    ]
    floor = OceanFloor.parse_lines(lines)
    expect(floor.lines).to eq([
      [[1, 2], [3, 4]],
      [[3, 4], [4, 5]],
    ])
  end

  it 'draws a line as expected' do
    lines = [
      '1,2 -> 1,4',
    ]
    floor = OceanFloor.parse_lines(lines)
    floor.draw_lines
    expect(floor.rows).to eq([
      [0, 0, 0, 0, 0],
      [0, 0, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ])
  end

  it 'draws a line as expected' do
    lines = [
      '0,2 -> 4,2',
    ]
    floor = OceanFloor.parse_lines(lines)
    floor.draw_lines
    expect(floor.rows).to eq([
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
    ])
  end

  it 'draws a diagonal line as expected' do
    lines = [
      '2,0 -> 0,2',
    ]
    floor = OceanFloor.parse_lines(lines)
    floor.draw_lines
    expect(floor.rows).to eq([
      [0, 0, 1],
      [0, 1, 0],
      [1, 0, 0],
    ])
  end

  it 'draws example lines as expected' do
    lines = [
      '0,9 -> 5,9',
      '8,0 -> 0,8',
      '9,4 -> 3,4',
      '2,2 -> 2,1',
      '7,0 -> 7,4',
      '6,4 -> 2,0',
      '0,9 -> 2,9',
      '3,4 -> 1,4',
      '0,0 -> 8,8',
      '5,5 -> 8,2'
    ]
    floor = OceanFloor.parse_lines(lines)
    floor.draw_lines
    expect(floor.to_s).to eq(<<~EOS.chomp)
      1.1....11.
      .111...2..
      ..2.1.111.
      ...1.2.2..
      .112313211
      ...1.2....
      ..1...1...
      .1.....1..
      1.......1.
      222111....
    EOS
  end

end
