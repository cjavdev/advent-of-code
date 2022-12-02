# Part 1
#   A - Rock
#   B - Paper
#   C - Scissors
#
#   X - Rock - 1
#   Y - Paper - 2
#   Z - Scissors - 3
# result = File
#   .readlines(ARGV.first)
#   .map(&:chomp)
#   .map {_1.split(' ')}
#   .sum do |them, me|
#     case [them, me]
#     in ['A', 'Z'] | ['C', 'Y'] | ['B', 'X']
#       0
#     in ['A', 'X'] | ['B', 'Y'] | ['C', 'Z']
#       3
#     else
#       6
#     end - 87 + me.ord
#   end
# p result

if __FILE__ == $0
  result = File
    .readlines(ARGV.first)
    .map(&:chomp)
    .map {_1.split(' ')}
    .map do |them, result|
      case [them, result]
      in ['A', 'Y'] | ['B', 'X'] | ['C', 'Z']
        1
      in ['A', 'Z'] | ['B', 'Y'] | ['C', 'X']
        2
      in ['A', 'X'] | ['B', 'Z'] | ['C', 'Y']
        3
      end + ((result.ord - 88) * 3)
    end
    .sum

  p result
end

