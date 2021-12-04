def number_of_increases(input)
  input.each_cons(2).count { |a, b| a < b }
end

def sum_of_windows(n, input)
  input.each_cons(n).map { |a| a.reduce(:+) }
end

if __FILE__ == $0
  raw_depths = File.readlines(ARGV.first).map(&:to_i)

  # Part 1
  # puts number_of_increases(raw_depths)

  # Part 2
  window_sums = sum_of_windows(3, raw_depths)
  p window_sums
  puts number_of_increases(window_sums)
end
