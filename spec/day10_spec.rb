require_relative '../day10/syntax.rb'
require 'byebug'

RSpec.describe Subsystem do
  it 'gets the score right' do
    lines = [
      '[({(<(())[]>[[{[]{<()<>>',
      '[(()[<>])]({[<{<<[]>>(',
      '{([(<{}[<>[]}>{[]{[(<()>',
      '(((({<>}<{<{<>}{[]{[]{}',
      '[[<[([]))<([[{}[[()]]]',
      '[{[{({}]{}}([{[{{{}}([]',
      '{<[[]]>}<{[{[{[]{()[[[]',
      '[<(<(<(<{}))><([]([]()',
      '<{([([[(<>()){}]>(<<{{',
      '<{([{{}}[<[[[<>{}]]]>[]]',
    ]
    lines.map! {Line.new(_1)}
    sys = Subsystem.new(lines)
    expect(sys.score).to eq(26397)
  end
end

RSpec.describe Line do
  it 'scores as expected' do
    line = Line.new('<{([')
    expect(line.score).to eq(294)
  end

  it 'knows the sequence to complete the line' do
    line = Line.new('[(<>)')
    expect(line.fix).to eq([']'])
  end

  it 'knows if the line is corrupted' do
    line = Line.new('[(<>)}')
    expect(line).to be_corrupted
    line = Line.new('[(<>)')
    expect(line).not_to be_corrupted
  end

  it 'finds an illegal char with simple case' do
    line = Line.new('[(<>)}')
    expect(line.illegal_char).to eq('}')
  end

  it 'finds an illegal char with simple case' do
    line = Line.new('[(<>(){}[])}()')
    expect(line.illegal_char).to eq('}')
  end
end
