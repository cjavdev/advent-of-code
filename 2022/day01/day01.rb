require 'byebug'

# data = DATA
data = File.read(ARGV.first)

# part 1
# p data
#   .each_line
#   .map(&:chomp)
#   .chunk_while { |a, b| b != '' }
#   .map { _1.map(&:to_i) }
#   .map(&:sum)
#   .max

# part 2
p data
  .each_line
  .map(&:chomp)
  .chunk_while { |a, b| b != '' }
  .map { _1.map(&:to_i) }
  .map(&:sum)
  .sort[-3..-1]
  .sum

__END__
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
