exmple = <<~EXAMPLE
3   4
4   3
2   5
1   3
3   9
3   3
EXAMPLE

input = File.open("./2024/day01/input").read
# input = exmple

left, right = input
  .split("\n")
  .map { |line| line.split.map(&:to_i) }
  .transpose
  .map(&:sort)

# PART 1
puts left.zip(right).map { |l, r| (l - r).abs }.sum

# PART 2
puts left.map { |l| right.count { |r| r == l } * l }.sum
