require 'set'
if ARGV.empty?
  data = DATA.readlines(chomp: true)
  y = 10
  max_x_y = 20
else
  data = File.readlines(ARGV[0], chomp: true)
  y = 2000000
  max_x_y = 4000000
end

def distance(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end


sensors = Set.new
beacons = Set.new

puts "Parsing lines..."
lines = data.map do |line|
  /Sensor at x=(?<x>-?\d+), y=(?<y>-?\d+): closest beacon is at x=(?<bx>-?\d+), y=(?<by>-?\d+)/.match(line)
end.map do |match|
  sensor = [match[:x].to_i, match[:y].to_i]
  beacon = [match[:bx].to_i, match[:by].to_i]
  d = distance(sensor, beacon)
  sensors << [sensor, d]
  beacons << beacon
end

exclude = Set.new

# gets the points around a point that are distance d from the point
def get_points(pt, d)
  x, y = pt
  points = Set.new
  (-d..d).each do |dx|
    dy = d - dx.abs
    points << [x + dx, y + dy]
    points << [x + dx, y - dy]
  end
  points
end

puts "Finding edge plus one..."
edge_plus_one = Set.new
sensors.each do |(x, y), d|
  # edge_plus_one += get_points(sensor, d + 1)
  d = d + 1
  (-d..d).each do |dx|
    dy = d - dx.abs
    nx = x + dx
    next if nx < 0 || nx > max_x_y
    next if y + dy < 0 || y + dy > max_x_y
    next if y - dy < 0 || y - dy > max_x_y

    edge_plus_one << [x + dx, y + dy]
    edge_plus_one << [x + dx, y - dy]
  end
end

p "Found #{edge_plus_one.size} points"

puts "Checking all the edge plus one points..."
edge_plus_one.each do |pt|
  if pt[0] < 0 || pt[1] < 0 || pt[0] > max_x_y || pt[1] > max_x_y
    exclude << pt
    next
  end
  sensors.each do |sensor, d|
    if distance(pt, sensor) <= d
      exclude << pt
      break
    end
  end
end


pt = (edge_plus_one - exclude).first
puts "Part 2: #{pt[0] * 4000000 + pt[1]}"

# puts "Big loop..."
# (-10_000_000..10_000_000).each do |x|
#   sensors.each do |(sx, sy), d|
#     if (sx - x).abs + (sy - y).abs <= d
#       exclude << [x, y] if !beacons.include?([x, y])
#       break
#     end
#   end
# end


# Get all the points that are distance + 1 from a sensor
# d_plus_1 = Set.new
# sensors.each do |(sx, sy), d|
#   exclude << [sx + dx, sy + dy]
# end

# Check all of those points to find the ones that are not in range
# of any sensors.



# require 'rspec/autorun'
#
# RSpec.describe "day15" do
#   it 'gets the points around a point that are distance x' do
#     points = get_points([0, 0], 1)
#     expect(points).to eq([[1, 0], [0, 1], [-1, 0], [0, -1]].sort)
#
#     points = get_points([0, 0], 2)
#     expect(points).to eq([[2, 0], [1, 1], [0, 2], [-1, 1], [-2, 0], [-1, -1], [0, -2], [1, -1]].sort)
#   end
# end

# p exclude.size
# p beacons
# p lines

__END__
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
