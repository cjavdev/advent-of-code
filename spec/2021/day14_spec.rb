require_relative '../day14/polymer.rb'

RSpec.describe Polymer do
  it 'PART2 does a step correctly' do
    polymer = Polymer.new('AB', {
      'AB' => 'C',
      'AC' => 'B',
      'BC' => 'A',
      'BA' => 'C',
      'CB' => 'C',
      'CC' => 'A'
    })
    polymer.step
    expect(polymer.template).to eq({
      'AB' => 0,
      'AC' => 1,
      'CB' => 1
    })
  end

  it 'part2 works with thingy' do
    polymer = Polymer.new('ACB', {
      'AB' => 'C',
      'AC' => 'B',
      'BC' => 'A',
      'BA' => 'C',
      'CB' => 'C',
      'CC' => 'A'
    })
    # ABCCB
    polymer.step
    expect(polymer.template).to eq({
      'AB' => 1,
      'AC' => 0,
      'BC' => 1,
      'CB' => 1,
      'CC' => 1,
    })
  end

  it 'works for even longer string' do
    polymer = Polymer.new('ABCCB', {
      'AB' => 'C',
      'AC' => 'B',
      'BC' => 'A',
      'BA' => 'C',
      'CB' => 'C',
      'CC' => 'A',
      'CA' => 'C'
    })

    # ABCCB => ACBACACCB
    polymer.step
    expect(polymer.template).to eq({
      'AB' => 0,
      'AC' => 3,
      'CB' => 2,
      'AB' => 0,
      'BC' => 0,
      'CC' => 1,
      'BA' => 1,
      'CA' => 1
    })

    # ACBACACCB => ABCCBCABCCABCACCB
    polymer.step
    expect(polymer.template).to eq({
      'AB' => 3,
      'AC' => 1,
      'BA' => 0,
      'BC' => 4,
      'CA' => 3,
      'CB' => 2,
      'CC' => 3,
    })
    expect(polymer.score_counter).to eq({
      'A' => 4,
      'B' => 5,
      'C' => 8
    })
    expect(polymer.score).to eq(8 - 4)
  end

  it 'PART1 does a step correctly' do
    polymer = Polymer.new('AB', {
      'AB' => 'C',
      'AC' => 'D',
      'CB' => 'E',
      'AD' => 'F',
      'DC' => 'G',
      'CE' => 'H',
      'EB' => 'A',
    })
    polymer.step
    polymer.step
    polymer.step
    expect(polymer.score).to eq(1)
  end
end
