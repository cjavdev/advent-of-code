require '../day1/depths.rb'

RSpec.describe "day1" do
  it 'handles empty list of depths' do
    depths = DepthCollection.new([])
    expect(depths.number_of_depth_increases).to eq(0)
  end

  it 'handles a list with one item as expected' do
    depths = DepthCollection.new([1])
    expect(depths.number_of_depth_increases).to eq(0)
  end

  it 'handles a list with single increase' do
    depths = DepthCollection.new([2, 1, 2])
    expect(depths.number_of_depth_increases).to eq(1)
  end

  it 'handles a list with zero increases' do
    depths = DepthCollection.new([2, 1, 1])
    expect(depths.number_of_depth_increases).to eq(0)
  end

  it 'handles a list with two increases' do
    depths = DepthCollection.new([2, 1, 1, 2, 3])
    expect(depths.number_of_depth_increases).to eq(2)
  end

  it 'accurately finds 7 for the example' do
    depths = DepthCollection.new([
      199,
      200,
      208,
      210,
      200,
      207,
      240,
      269,
      260,
      263
    ])
    expect(depths.number_of_depth_increases).to eq(7)
  end
end
