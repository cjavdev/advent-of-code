require '../day7/crabs.rb'

RSpec.describe Crabs do
  # it 'calculates fuel required for one hop' do
  #   crabs = Crabs.new([1, 4])
  #   expect(crabs.min_fuel).to eq(3)
  # end
  #
  # it 'calculates fuel required for two hops' do
  #   crabs = Crabs.new([1, 3, 4])
  #   expect(crabs.min_fuel).to eq(3)
  # end
  #
  # it 'calculates fuel required for two hops' do
  #   crabs = Crabs.new([1, 3, 4, 8])
  #   expect(crabs.min_fuel).to eq(8)
  # end

  # it 'works for the example input' do
  #   crabs = Crabs.new([1, 4])
  #   expect(crabs.min_fuel).to eq(168)
  # end
  it 'works for the example input' do
    crabs = Crabs.new([16, 1, 2, 0, 4, 2, 7, 1, 2, 14])
    expect(crabs.min_fuel).to eq(168)
  end
end
