require 'byebug'

class Array
  def median
    return if length == 0
    middle_index = (length / 2).ceil
    puts "Len: #{length} mi: #{middle_index}"
    self[middle_index]
  end
end

class Diagnostic
  attr_reader :measurements

  def initialize(measurements, gamma_rate=nil)
    @measurements = measurements.sort
    @gamma_rate = gamma_rate
  end

  def gamma_rate
    half_measurement_count = measurements.count / 2
    # Negative numbers mean 0 is most common
    # Positive numbers mean 1 is most common

    @gamma_rate ||= bit_frequency
      .map {|x| x > half_measurement_count && 1 || 0 }
      .join
      .to_i(2)
  end

  def epsilon_rate
    gamma_rate ^ (["1"] * max_width).join.to_i(2)
  end

  def oxygen_rate
    oxygen_rate_bits.to_i(2)
  end

  def co2_rate
    co2_rate_bits.to_i(2)
  end

  protected

  def gamma_bits
    @_gb ||= gamma_rate.to_s(2).rjust(max_width, '0')
  end

  def epsilon_bits
    @_eb ||= epsilon_rate.to_s(2).rjust(max_width, '0')
  end

  private

  def measurement_bits
    # Convert the numbers into strings of binary digits
    @_mb ||= measurements.map { |m| m.to_s(2).rjust(max_width, '0') }
  end

  def max_width
    @max_width ||= measurements.map {_1.to_s(2)}.max_by(&:length).length
  end

  def bit_frequency
    # Create a counter for each bit position
    counter = Array.new(max_width, 0)

    measurement_bits.each do |m|
      # reverse, so that we're always starting with the least significant bit
      m.chars.reverse.each_with_index do |c, i|
        # If the bit is a 1, increment the counter
        counter[i] += 1 if c == '1'
      end
    end

    counter.reverse
  end

  def oxygen_rate_bits
    included_measurements = measurement_bits

    max_width.times do |i|
      mid = included_measurements.median
      # if the bit at the mid point is 1, keep all that are greater than or equal to
      left, right = included_measurements.partition do |el|
        el[i] == mid[i]
      end

      next if included_measurements.length == 1
      included_measurements = left
    end

    included_measurements.first
  end

  def co2_rate_bits
    included_measurements = measurement_bits

    max_width.times do |i|
      mid = included_measurements.median
      # if the bit at the mid point is 1, keep all that are greater than or equal to
      left, right = included_measurements.partition do |el|
        el[i] != mid[i]
      end

      next if included_measurements.length == 1
      included_measurements = left
    end

    included_measurements.first
  end
end

if __FILE__ == $0
  # Part 1
  # Manually found gamma - 0b000101011101
  measurements = File.readlines(ARGV.first).map {|x|x.to_i(2)}
  diagnostic = Diagnostic.new(measurements)
  o2 = diagnostic.oxygen_rate
  diagnostic = Diagnostic.new(measurements)
  co2 = diagnostic.co2_rate
  puts o2 * co2
end
