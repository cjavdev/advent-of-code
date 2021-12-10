require_relative '../day9/height_map.rb'
require 'byebug'

RSpec.describe HeightMap do
  let(:map) do
    HeightMap.new([
      [2, 1, 9],
      [3, 9, 8],
      [9, 8, 5],
    ])
  end

  let(:map2) do
    HeightMap.new([
      [2, 9, 0],
      [3, 9, 8],
      [9, 8, 5],
    ])
  end

  let(:example_map) do
    HeightMap.new([
      [2, 1, 9, 9, 9, 4, 3, 2, 1, 0],
      [3, 9, 8, 7, 8, 9, 4, 9, 2, 1],
      [9, 8, 5, 6, 7, 8, 9, 8, 9, 2],
      [8, 7, 6, 7, 8, 9, 6, 7, 8, 9],
      [9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
    ])
  end

  it 'detects basin neighbors' do
    expect(map.basin_points([0, 0])).to contain_exactly(
      [0, 0],
      [1, 0],
      [0, 1]
    )
  end

  it 'example_map_tests' do
    expect(example_map.risk_level).to eq(15)
    expect(example_map.basin_values).to eq(1134)
  end

  it 'calculats the risk level as expected' do
    expect(map.risk_level).to eq(8)
  end

  it 'detects a low point' do
    expect(map2.low_point?([0, 2])).to be(true)
  end

  it 'detects a low point' do
    expect(map.low_point?([0, 0])).to be(false)
    expect(map.low_point?([1, 1])).to be(false)
    expect(map.low_point?([0, 1])).to be(true)
    expect(map.low_point?([2, 2])).to be(true)
  end

  it 'finds the neighbor values of a point' do
    expect(map.neighbor_values([0, 0])).to contain_exactly(1, 3)
    expect(map.neighbor_values([1, 1])).to contain_exactly(1, 3, 8, 8)
    expect(map.neighbor_values([2, 2])).to contain_exactly(8, 8)
  end

  it 'finds the neighbors of a point' do
    expect(map.neighbors([0, 0])).to eq([
      [1, 0],
      [0, 1],
    ])
    expect(map.neighbors([1, 1])).to eq([
      [0, 1],
      [2, 1],
      [1, 0],
      [1, 2],
    ])
  end

  it 'finds low points' do

    expect(map.low_points).to eq([
      [0, 1],
      [2, 2]
    ])
  end
end
