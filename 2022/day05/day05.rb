def read_towers(data)
  towers = []
  data
    .split("\n")
    .map { |line| line.split(/\s{4}| /) }
    .reverse
    .map
    .with_index do |level, i|
      next if i == 0

      level
        .map {|element| element.gsub(/\[|\]/, '') }
        .each_with_index do |element, index|
        next if element == ""
        towers[index] = [] unless towers[index]
        towers[index] << element
      end
    end
  towers
end

def read_instructions(data)
  data
    .split("\n")
    .map { |line| /move (?<n>\d+) from (?<from>\d+) to (?<to>\d+)/.match(line) }
    .map { |match| [match[:n].to_i, match[:from].to_i, match[:to].to_i] }
end

# Move n elements from the from tower to the to tower.
def move(towers, n, from, to)
  # part 1
  n.times do
    towers[to - 1] << towers[from - 1].pop
  end
  # towers[to - 1] += towers[from - 1].pop(n)
end

def move_all(towers, instructions)
  instructions.each do |instruction|
    move(towers, *instruction)
  end
end

def result(towers)
  towers.map(&:last).join
end

if ARGV.empty?
  require 'rspec/autorun'

  RSpec.describe 'deserialization' do
    before(:all) do
      @data, @instructions = DATA.read.split("\n\n")
    end

    it 'full send' do
      towers = read_towers(@data)
      move_all(towers, read_instructions(@instructions))
      expect(towers).to eq([["C"], ["M"], ["P", "D", "N", "Z"]])
      expect(result(towers)).to eq("CMZ")
    end

    it 'puts the stacks in the right spots' do
      towers = read_towers(@data)
      expect(towers.length).to eq(3), towers
      expect(towers[0].length).to eq(2)
      expect(towers[0][0]).to eq('Z')
      expect(towers[0][1]).to eq('N')

      expect(towers[1].length).to eq(3)
      expect(towers[1][0]).to eq('M')
      expect(towers[1][1]).to eq('C')
      expect(towers[1][2]).to eq('D')

      expect(towers[2].length).to eq(1)
      expect(towers[2][0]).to eq('P')
    end

    it 'moves a disk' do
      towers = read_towers(@data)
      move(towers, 1, 2, 1)

      expect(towers[0].length).to eq(3)
      expect(towers[0][0]).to eq('Z')
      expect(towers[0][1]).to eq('N')
      expect(towers[0][2]).to eq('D')
      expect(towers[1].length).to eq(2)
      expect(towers[1][0]).to eq('M')
      expect(towers[1][1]).to eq('C')

      expect(towers[2].length).to eq(1)
      expect(towers[2][0]).to eq('P')

      move(towers, 3, 1, 3)

      expect(towers[0].length).to eq(0)
      expect(towers[1].length).to eq(2)
      expect(towers[2].length).to eq(4)

      move(towers, 2, 2, 1)

      expect(towers[0].length).to eq(2)
      expect(towers[1].length).to eq(0)
      expect(towers[2].length).to eq(4)
      expect(towers[0][0]).to eq('C')

      move(towers, 1, 1, 2)
    end
  end
else
  data, instructions = File.read(ARGV[0]).split("\n\n")
  towers = read_towers(data)
  instructions = read_instructions(instructions)
  move_all(towers, instructions)
  p result(towers)
end


__END__
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
