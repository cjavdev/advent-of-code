class DepthCollection
  def initialize(depths)
    @depths = depths
  end

  def number_of_depth_increases
    @depths.each_cons(2).count { |a, b| a < b }
  end
end

if __FILE__ == $0
  raw_depths = File.readlines(ARGV.first).map(&:to_i)
  puts DepthCollection.new(raw_depths).number_of_depth_increases
end
