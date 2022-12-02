require '../day8/segments.rb'
require 'byebug'

RSpec.describe Segments do
  it 'does stuff' do
    segments = Segments.parse('fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb')
    expect(segments.output_number).to eq(8418)
  end

  it 'calculates the output number' do
    segments = Segments.parse('acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf')
    expect(segments.output_number).to eq(5353)
    segments = Segments.parse('be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe')
    expect(segments.output_number).to eq(8394)
  end

  it 'finds stuff' do
    segments = Segments.parse('acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf | ab')
    expect(segments.top_right).to eq('a')
    expect(segments.bottom_right).to eq('b')
    expect(segments.bottom_left).to eq('g')
    expect(segments.top).to eq('d')
    expect(segments.middle).to eq('f')

    expect(segments.zero).to eq('abcdeg')
    expect(segments.one).to eq('ab')
    expect(segments.two).to eq('acdfg')
    expect(segments.three).to eq('abcdf')
    expect(segments.four).to eq('abef')
    expect(segments.five).to eq('bcdef')
    expect(segments.six).to  eq('bcdefg')
    expect(segments.seven).to eq('abd')
    expect(segments.eight).to eq('abcdefg')
    expect(segments.nine).to eq('abcdef')
  end

  it 'finds six' do
    segments = Segments.parse('acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf | ab')
    expect(segments.top_right).to eq('a')
    expect(segments.six).to eq('bcdefg')
  end

  it 'finds the right segments for 7s' do
    segments = Segments.parse('acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf | ab')
    expect(segments.top).to eq('d')
    expect(segments.top_right).to eq('a')
    expect(segments.bottom_right).to eq('b')
  end

  it 'finds the right segments for 7s' do
    segments = Segments.parse('acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf | ab')
    expect(segments.top).to eq('d')
    expect(segments.top_right).to eq('a')
    expect(segments.bottom_right).to eq('b')
  end

  it 'finds the right segments for 1s' do
    segments = Segments.parse('acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf | ab')
    expect(segments.top_right).to eq('a')
    expect(segments.bottom_right).to eq('b')
  end

  it 'parses the input into expected patterns and output' do
    segments = Segments.parse('acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf')
    expect(segments.patterns).to eq([
      'abcdefg',
      'bcdef',
      'acdfg',
      'abcdf',
      'abd',
      'abcdef',
      'bcdefg',
      'abef',
      'abcdeg',
      'ab',
    ])
    expect(segments.output).to eq([
      'bcdef',
      'abcdf',
      'bcdef',
      'abcdf'
    ])
  end
end
