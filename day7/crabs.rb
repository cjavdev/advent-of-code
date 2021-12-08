require 'byebug'
class Crabs
  attr_reader :positions

  def initialize(positions)
    @positions = positions
  end

  def min_fuel
    min_fuel = Float::INFINITY
    ap = nil
    min = positions.min
    max = positions.max
    point_fuels = Hash.new(0)
    min.upto(max).each do |align_point|
      @positions.each do |pos|
        # Part 1, simple solution
        # point_fuels[align_point] += (pos - align_point).abs

        # Part 2, thingy
        distance = (pos - align_point).abs
        fuel = ((distance * (distance + 1)) / 2.0).ceil
        # puts "ap: #{align_point}, pos: #{ pos }, fuel: #{ fuel }"
        point_fuels[align_point] += fuel
      end
      if point_fuels[align_point] < min_fuel
        min_fuel = point_fuels[align_point]
        ap = align_point
      end
    end
    puts ap
    min_fuel
  end
end

if __FILE__ == $0
  input = File.read(ARGV.first).split(",").map(&:to_i)
  crabs = Crabs.new(input)
  puts crabs.min_fuel
end
