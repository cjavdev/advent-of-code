def valid(a, b)
  return nil if a.empty? && b.empty?
  return true if a.empty?
  return false if b.empty?

  a_head, *a_tail = a
  b_head, *b_tail = b

  case [a_head, b_head]
  in [Integer, Integer]
    return true if a_head < b_head
    return false if a_head > b_head
  in [Integer, Array]
    result = valid([a_head], b_head)
  in [Array, Integer]
    result = valid(a_head, [b_head])
  in [Array, Array]
    result = valid(a_head, b_head)
  end

  result.nil? ? valid(a_tail, b_tail) : result
end

if ARGV.empty?
  require 'rspec/autorun'
  RSpec.describe 'Day 13' do
    it 'works for the example input' do
      a = [1,1,3,1,1]
      b = [1,1,5,1,1]
      expect(valid(a, b)).to be(true)

      a = [[1],[2,3,4]]
      b = [[1],4]
      expect(valid(a, b)).to be(true)

      a = [9]
      b = [[8,7,6]]
      expect(valid(a, b)).to be(false)

      a = [[4,4],4,4]
      b = [[4,4],4,4,4]
      expect(valid(a, b)).to be(true)

      a = [7,7,7,7]
      b = [7,7,7]
      expect(valid(a, b)).to be(false)

      a = []
      b = [3]
      expect(valid(a, b)).to be(true)

      a = [[[]]]
      b = [[]]
      expect(valid(a, b)).to be(false)

      a = [1,[2,[3,[4,[5,6,7]]]],8,9]
      b = [1,[2,[3,[4,[5,6,0]]]],8,9]
      expect(valid(a, b)).to be(false)
    end
  end

  data = DATA.read
else
  data = File.read(ARGV.first)
end

# PART 1
# p data
#   .split("\n\n")
#   .map { _1.split("\n").map(&method(:eval)) }
#   .map { |a, b| valid(a, b) }
#   .each_with_index
#   .inject(0) { |sum, (v, i)| sum + (v ? i + 1 : 0) }

# PART 2
with_decoders = data
  .split("\n")
  .map(&:chomp)
  .reject {_1 == ''}
  .map(&method(:eval))
  .push([[2]])
  .push([[6]])
  .sort {|a, b| valid(a, b) ? -1 : 1 }

a = with_decoders.find_index([[2]]) + 1
b = with_decoders.find_index([[6]]) + 1
p a * b


__END__
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
