require 'byebug'

def width(measurements)
  # Convert the numbers into strings of binary digits
  measurement_bits = measurements.map { |m| m.to_s(2) }

  # Find the widest number of bits
  measurement_bits.max_by(&:length).length
end

def gamma_rate(measurements)
  # Convert the numbers into strings of binary digits
  measurement_bits = measurements.map { |m| m.to_s(2) }

  # Find the widest number of bits
  width = width(measurements)

  # Create a counter for each bit position
  counter = Array.new(width, 0)

  measurement_bits.each do |m|
    # reverse, so that we're always starting with the least significant bit
    m.chars.reverse.each_with_index do |c, i|
      # If the bit is a 1, increment the counter
      counter[i] += 1 if c == '1'
    end
  end

  # Negative numbers mean 0 is most common
  # Positive numbers mean 1 is most common
  counter
    .reverse
    .map {|x| x > (measurements.count / 2) && 1 || 0 }
    .join.to_i(2)
end

def epsilon_rate(n, width)
  n ^ (["1"] * width).join.to_i(2)
end

if __FILE__ == $0
  # Part 1
  # puts 0b000101011101

  measurements = File.readlines(ARGV.first).map {|x|x.to_i(2)}
  p measurements.length
  g = gamma_rate(measurements)
  e = epsilon_rate(g, width(measurements))
  puts g
  puts e
  puts g * e
end
