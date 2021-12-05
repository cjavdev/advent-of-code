require '../day3/diagnostic.rb'
require 'byebug'

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
end
