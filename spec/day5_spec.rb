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

end
