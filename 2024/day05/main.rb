require "byebug"
input = <<~INPUT
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
INPUT

input = File.open("2024/day05/input").read

def valid?(rules, number_set)
  number_set.length.times do |i|
    rest = number_set[i + 1..]
    supported = rules[number_set[i]]

    return false if !rest.all? { |r| supported.include?(r) }
  end

  true
end

rules, numbers = input.split("\n\n")

numbers = numbers.split("\n").map do |line|
  line.split(",").map(&:to_i)
end

rules = rules.split("\n").map do |line|
  line.split("|").map(&:to_i)
end.inject(Hash.new { |h, k| h[k] = [] }) do |acc, (left, right)|
  acc[left] << right
  acc
end

p numbers
p rules

# Part 1
mids = numbers.map do |number_set|
  if valid?(rules, number_set)
    number_set[number_set.length / 2]
  else
    0
  end
end
puts "Part 1"
p mids.sum


def sort(rules, number_set)
  number_set.sort do |a, b|
    !rules[a].include?(b) ? 1 : -1
  end
end

# Part 2
mids = numbers.map do |number_set|
  if valid?(rules, number_set)
    0
  else
    sorted_number_set = sort(rules, number_set)
    sorted_number_set[number_set.length / 2]
  end
end

puts "Part 2"
p mids.sum

# a = [75,97,47,61,53]
# p [a, sort(rules, a), [97,75,47,61,53]]