require '../day3/diagnostic.rb'
require 'byebug'

def gamma_rate(input)
  Diagnostic.new(input).gamma_rate
end

def epsilon_rate(input)
  Diagnostic.new([input], gamma_rate=input).epsilon_rate
end

RSpec.describe 'diagnostic' do

  it 'calculates the gamma rate for a small list of readings' do
    gamma = gamma_rate([
      0b00100,
      0b11110,
      0b10110
    ])
    expect(gamma).to eq(0b10110)
  end

  it 'works for example input' do
    gamma = gamma_rate([
      0b00100,
      0b11110,
      0b10110,
      0b10111,
      0b10101,
      0b01111,
      0b00111,
      0b11100,
      0b10000,
      0b11001,
      0b00010,
      0b01010
    ])
    expect(gamma).to eq(0b10110)
  end

  it 'calculates the epsilon rate' do
    epsilon = epsilon_rate(0b10110)
    expect(epsilon).to eq(0b01001)
  end

  it 'calculates the oxygen rate for 3 measurements' do
    diagnostic = Diagnostic.new([
      0b00100,
      0b10110,
      0b11110,
    ])
    expect(diagnostic.oxygen_rate).to eq(0b11110)
  end

  it 'calculates the oxygen rate for the example input' do
    diagnostic = Diagnostic.new([
      0b00100,
      0b11110,
      0b10110,
      0b10111,
      0b10101,
      0b01111,
      0b00111,
      0b11100,
      0b10000,
      0b11001,
      0b00010,
      0b01010
    ])
    expect(diagnostic.oxygen_rate).to eq(23)
  end

  it 'Array#median finds median' do
    a = [1, 2, 3, 4, 5]
    expect(a.median).to eq(3)
    a = [1, 2, 3, 4]
    expect(a.median).to eq(3)
    a = [1, 2, 3]
    expect(a.median).to eq(2)
    a = [1, 2]
    expect(a.median).to eq(2)
    a = [1]
    expect(a.median).to eq(1)
    a = []
    expect(a.median).to eq(nil)
  end
end
