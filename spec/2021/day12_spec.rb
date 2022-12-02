require_relative '../day12/caves.rb'

RSpec.describe Caves do
  it 'stores the possible paths' do
    caves = Caves.new([
      'start-A',
      'start-b',
      'A-c',
      'A-b',
      'b-d',
      'A-end',
      'b-end'
    ])
    expect(caves.routes).to eq({
      'start' => Cave.new('start', ['A', 'b']),
      'A' => Cave.new('A', ['c', 'b', 'end']),
      'b' => Cave.new('b', ['d', 'end']),
    })
  end

  it 'calculates the paths from start' do
    caves = Caves.new([
      'start-A',
      'start-b',
      'A-c',
      'A-b',
      'b-d',
      'A-end',
      'b-end'
    ])
    expect(caves.paths).to contain_exactly(
      ['start','A','b','A','c','A','end'],
      ['start','A','b','A','end'],
      ['start','A','b','end'],
      ['start','A','c','A','b','A','end'],
      ['start','A','c','A','b','end'],
      ['start','A','c','A','end'],
      ['start','A','end'],
      ['start','b','A','c','A','end'],
      ['start','b','A','end'],
      ['start','b','end'],
    )
  end
end
