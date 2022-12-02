require_relative '../day15/graph.rb'

RSpec.describe Graph do
  it 'calculates the total risk level' do
    graph = Graph.new([
      [1, 1, 6],
      [1, 3, 8],
      [2, 1, 3],
    ])
    expect(graph.calculate).to eq(7)
  end

  it 'size doubles the ' do
    graph = Graph.new([
      [1, 1, 6],
      [1, 3, 8],
      [2, 1, 3],
    ], 2)
    expect(graph.risk_levels).to eq([
      [1, 1, 6, 2, 2, 7],
      [1, 3, 8, 2, 4, 9],
      [2, 1, 3, 3, 2, 4],
      [2, 2, 7, 3, 3, 8],
      [2, 4, 9, 3, 5, 1],
      [3, 2, 4, 4, 3, 5],
    ])
    # expect(graph.calculate).to eq(26)
  end

  it 'works' do
    graph = Graph.new([
      [1, 1, 6, 3, 7, 5, 1, 7, 4, 2],
    ], 5)
    expect(graph.risk_levels[0]).to eq(
      "11637517422274862853338597396444961841755517295286".chars.map(&:to_i)
    )
  end


  it 'grows a single element as expected' do
    graph = Graph.new([
      [1, 1],
      [8, 8],
    ], 3)
    # p graph.risk_levels.length
    expect(graph.risk_levels).to eq([
      [1, 1, 2, 2, 3, 3],
      [8, 8, 9, 9, 1, 1],
      [2, 2, 3, 3, 4, 4],
      [9, 9, 1, 1, 2, 2],
      [3, 3, 4, 4, 5, 5],
      [1, 1, 2, 2, 3, 3]
    ])
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
    min_risk = graph.calculate
    expect(min_risk).to eq(40)
  end
end
