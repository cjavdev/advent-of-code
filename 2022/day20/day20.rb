def mix(data)
  data.length.times do |i|
    # Rotate until head is data[i]
    data.rotate! until data.first.last == i

    # Pull off the head
    head, *tail = data
    data = [
      head,
      *tail.rotate(head.first) # Rotate the tail head times
    ].rotate(-head.first) # Unwind the rotation
  end

  # Rotate back to the start
  data.rotate! until data.first.last == 0
  data
end

def find_coords(numbers)
  zero_index = numbers.find_index(0)
  numbers = numbers.cycle.take(zero_index + 3005)

  one_k = numbers[zero_index+1000]
  two_k = numbers[zero_index+2000]
  three_k = numbers[zero_index+3000]
  puts "1000: #{one_k}"
  puts "2000: #{two_k}"
  puts "3000: #{three_k}"
  puts "ans = #{one_k + two_k + three_k}"
end

if ARGV.empty?
  data = [1, 2, -3, 3, -2, 0, 4]
else
  data = File.readlines(ARGV[0], chomp:true)
end

# Parse input
data = data.map(&:to_i).each_with_index.to_a

# Part 1
# # Mix it up for part 1
# mixed_numbers = mix(data)
#
# # Print the 1000th + 2000th + 3000th numbers
# # after the zero
# find_coords(mixed_numbers.map(&:first))

# Part 2
data = data.map {|n, i| [n * 811589153, i] }
10.times do |n|
  puts "Round #{n}"
  data = mix(data)
end
find_coords(data.map(&:first))
