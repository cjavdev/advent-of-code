require 'byebug'
require 'set'

def parse_moves(moves)
  moves
    .map(&:chomp)
    .map {_1.split(' ')}
    .map {[_1[0], _1[1].to_i]}
end

def follow(head, tail)
  if head[0] != tail[0] && head[1] != tail[1] && ((head[0] - tail[0]).abs > 1 || (head[1] - tail[1]).abs > 1)
    tail[1] += head[1] <=> tail[1]
    tail[0] += head[0] <=> tail[0]
  elsif (head[1] - tail[1]).abs > 1
    tail[1] += head[1] <=> tail[1]
  elsif (head[0] - tail[0]).abs > 1
    tail[0] += head[0] <=> tail[0]
  end
end

def move(visited, rope, direction, distance)
  head, *tail = rope
  distance.times do
    case direction
    when 'U' then head[1] += 1
    when 'D' then head[1] -= 1
    when 'R' then head[0] += 1
    when 'L' then head[0] -= 1
    end
    rope.each_cons(2) do |h, t|
      follow(h, t)
    end
    visited << rope.last.dup
  end
  rope
end

if !ARGV.empty?
  visited = Set.new
  # part 1
  # rope = Array.new(2) {Array.new(2, 0)}
  # part 2
  rope = Array.new(10) {Array.new(2, 0)}
  moves = parse_moves(File.readlines(ARGV[0]))
  moves.each do |(dir, dis)|
    rope = move(visited, rope, dir, dis)
  end
  puts visited.size
else
  require 'rspec/autorun'

  RSpec.describe 'Day 09' do
    before(:all) do
      @moves = parse_moves(DATA.readlines)
    end

    it 'moves the head and tail as expected for single directions' do
      visited = Set.new
      expect(move(visited, [[0, 0], [0, 0]], 'U', 5)).to eq([[0, 5], [0, 4]])
      expect(visited.size).to eq(5), visited.inspect

      visited = Set.new
      expect(move(visited, [[0, 0], [0, 0]], 'D', 5)).to eq([[0, -5], [0, -4]])
      expect(visited.size).to eq(5)

      expect(move(Set.new, [[0, 0], [0, 0]], 'R', 5)).to eq([[5, 0], [4, 0]])
      expect(move(Set.new, [[0, 0], [0, 0]], 'L', 5)).to eq([[-5, 0], [-4, 0]])
    end

    it 'moves the head and tail as expected for diagonal directions' do
      expect(move(Set.new, [[1, 1], [0, 0]], 'U', 1)).to eq([[1, 2], [1, 1]])
      expect(move(Set.new, [[-1, -1], [0, 0]], 'D', 1)).to eq([[-1, -2], [-1, -1]])
      expect(move(Set.new, [[-1, -1], [0, 0]], 'L', 1)).to eq([[-2, -1], [-1, -1]])
      expect(move(Set.new, [[1, 1], [0, 0]], 'R', 1)).to eq([[2, 1], [1, 1]])
    end

    it 'works for a rope of length 3' do
      visited = Set.new
      expect(move(visited, [[0, 0], [0, 0], [0, 0]], 'U', 5)).to eq([[0, 5], [0, 4], [0, 3]])
      expect(visited.size).to eq(4)
    end

    it 'works for the example case' do
      visited = Set.new
      head = [0, 0]
      tail = [0, 0]
      @moves.each do |(dir, dis)|
        head, tail = move(visited, [head, tail], dir, dis)
      end
      expect(visited.size).to eq(13)
    end

    it 'parses moves as expected' do
      expect(@moves).to eq([
        ['R', 4],
        ['U', 4],
        ['L', 3],
        ['D', 1],
        ['R', 4],
        ['D', 1],
        ['L', 5],
        ['R', 2],
      ])
    end
  end
end

__END__
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
