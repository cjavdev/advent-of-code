require_relative '../../2022/day02/day02.rb'

describe 'score' do
  # Part 1
  # it 'returns 6 when i win' do
  #   expect(score('A', 'Y')).to eq(6)
  #   expect(score('B', 'Z')).to eq(6)
  #   expect(score('C', 'X')).to eq(6)
  # end
  #
  # it 'returns 0 when i lose' do
  #   expect(score('A', 'Z')).to eq(0)
  #   expect(score('B', 'X')).to eq(0)
  #   expect(score('C', 'Y')).to eq(0)
  # end
  #
  # it 'returns 3 when i draw' do
  #   expect(score('A', 'X')).to eq(3)
  #   expect(score('B', 'Y')).to eq(3)
  #   expect(score('C', 'Z')).to eq(3)
  # end
  #
  # it 'works for the test cases' do
  #   [
  #     ['A', 'Y', 8],
  #     ['B', 'X', 1],
  #     ['C', 'Z', 6]
  #   ].each do |them, me, expected|
  #     expect(total(them, me)).to eq(expected)
  #   end
  # end
  # Part 2

  it 'score' do
    expect(score('X')).to eq(0)
    expect(score('Y')).to eq(3)
    expect(score('Z')).to eq(6)
  end

  it 'bonus' do
    # they throw rock and I need to lose so I throw scissors
    expect(bonus('A', 'X')).to eq(3)
    # they throw rock and I need to draw so I throw rock
    expect(bonus('A', 'Y')).to eq(1)
    # they throw rock and I need to win so I throw paper
    expect(bonus('A', 'Z')).to eq(2)

    # they throw paper and I need to lose so I throw rock
    expect(bonus('B', 'X')).to eq(1)
  end

  it 'returns 3 when i draw' do
    expect(score('A', 'X')).to eq(3)
    expect(score('B', 'Y')).to eq(3)
    expect(score('C', 'Z')).to eq(3)
  end

  it 'works for the test cases' do
    [
      ['A', 'Y', 4],
      ['B', 'X', 1],
      ['C', 'Z', 7]
    ].each do |them, me, expected|
      expect(bonus(them, me) + score(me)).to eq(expected)
    end
  end

end
