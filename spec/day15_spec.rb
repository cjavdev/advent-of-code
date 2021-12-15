require_relative '../day15/graph.rb'

RSpec.describe Graph do
  it 'calculates the total risk level' do
    graph = Graph.new([
      [1, 1, 6],
      [1, 3, 8],
      [2, 1, 3],
    ])
    graph.calculate2
    expect(graph.aggregate).to eq([
      [0, 1, 7],
      [1, 4, 12],
      [3, 4, 7]
    ])
    expect(graph.min_risk).to eq(7)
  end

  it 'works for example case' do
    graph = Graph.new([
      [1, 1, 6, 3, 7, 5, 1, 7, 4, 2],
      [1, 3, 8, 1, 3, 7, 3, 6, 7, 2],
      [2, 1, 3, 6, 5, 1, 1, 3, 2, 8],
      [3, 6, 9, 4, 9, 3, 1, 5, 6, 9],
      [7, 4, 6, 3, 4, 1, 7, 1, 1, 1],
      [1, 3, 1, 9, 1, 2, 8, 1, 3, 7],
      [1, 3, 5, 9, 9, 1, 2, 4, 2, 1],
      [3, 1, 2, 5, 4, 2, 1, 6, 3, 9],
      [1, 2, 9, 3, 1, 3, 8, 5, 2, 1],
      [2, 3, 1, 1, 9, 4, 4, 5, 8, 1],
    ])
    graph.calculate
    expect(graph.min_risk).to eq(40)
  end
end
