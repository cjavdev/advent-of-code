require '../day2/submarine.rb'

RSpec.describe Submarine do

  it 'can move forward' do
    submarine = Submarine.new
    submarine.forward(2)
    expect(submarine.horizontal_position).to eq(2)
    submarine.forward(3)
    expect(submarine.horizontal_position).to eq(5)
  end

  it 'can move up and down' do
    submarine = Submarine.new
    submarine.down(2)
    expect(submarine.depth).to eq(2)
    submarine.down(3)
    expect(submarine.depth).to eq(5)
    submarine.up(4)
    expect(submarine.depth).to eq(1)
  end

  it 'calculates the location as expected' do
    submarine = Submarine.new
    submarine.forward 5
    submarine.down 5
    submarine.forward 8
    submarine.up 3
    submarine.down 8
    submarine.forward 2
    expect(submarine.location).to eq(150)
  end

  it 'works with block syntax' do
    submarine = Submarine.new do
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
    end
    expect(submarine.location).to eq(150)
  end

end
