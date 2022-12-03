# data = DATA.readlines

data = File.readlines(ARGV.first)

# Part 1
# result = data
#   .map(&:chomp)
#   .map {_1.split(//)}
#   .map { _1.each_slice(_1.length / 2).to_a }
#   .map { _1.first & _1.last }
#   .flatten
#   .map do
#     _1 =~ /[A-Z]/ ? _1.ord - 64 + 26 : _1.ord - 96
#   end
#     .sum
def priority(a)
  a =~ /[A-Z]/ ? a.ord - 64 + 26 : a.ord - 96
end

# Part 2
result = data
  .map(&:chomp)
  .map {_1.split(//)}
  .each_slice(3)
  .map { _1 & _2 & _3 }
  .flatten
  .map { priority(_1) }
  .sum

p result

__END__
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
