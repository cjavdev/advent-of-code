require_relative '../day11/cavern.rb'
require 'byebug'

RSpec.describe Cavern do

  it 'increases all energy levels' do
    cavern = described_class.new([
      [1, 2, 3, 4],
      [5, 6, 3, 1],
    ])

    cavern.tick
    expect(cavern.energy_levels).to eq([
      [2, 3, 4, 5],
      [6, 7, 4, 2],
    ])
  end

  it 'flashes and causes other surrounding energy levels to rise' do
    cavern = described_class.new([
      [1, 1, 1, 1, 1],
      [1, 9, 9, 9, 1],
      [1, 9, 1, 9, 1],
      [1, 9, 9, 9, 1],
      [1, 1, 1, 1, 1],
    ])

    cavern.tick
    expect(cavern.energy_levels).to eq([
      [3,4,5,4,3],
      [4,0,0,0,4],
      [5,0,0,0,5],
      [4,0,0,0,4],
      [3,4,5,4,3],
    ])

    cavern.tick
    expect(cavern.energy_levels).to eq([
      [4, 5, 6, 5, 4],
      [5, 1, 1, 1, 5],
      [6, 1, 1, 1, 6],
      [5, 1, 1, 1, 5],
      [4, 5, 6, 5, 4],
    ])
  end
end
