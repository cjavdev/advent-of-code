require 'set'

def get_points((x, y, z))
  [
    [1, 0, 0],
    [-1, 0, 0],
    [0, 1, 0],
    [0, -1, 0],
    [0, 0, 1],
    [0, 0, -1]
  ].map do |dx, dy, dz|
    [x + dx, y + dy, z + dz]
  end
end

def exposed_area(cubes)
  cubes.inject(0) do |area, cube|
    area + get_points(cube).inject(0) do |area2, point|
      # Only count the points that are not in the cube set
      cubes.include?(point) ? area2 : area2 + 1
    end
  end
end

def exterior_area(cubes)
  air_gap_points = Set.new

  bounds = cubes.minmax.flatten

  cubes.each do |cube|
    get_points(cube).each do |point|
      if touches_air?(point, cubes, bounds)
        puts "#{point} touches air"
      else
        air_gap_points.add(point)
        puts "#{point} doesn't touch air"
      end
    end
  end

  external_cubes = Set.new
  cubes.each do |cube|
    get_points(cube).each do |point|
      if air_gap_points.include?(point)
        external_cubes << cube
      end
    end
  end

  exposed_area(external_cubes)
end

# If a cube can reach the bounds without
# hitting another cube, it's touching air.
def touches_air?(cube, cubes, bounds)
  min_x, min_y, min_z, max_x, max_y, max_z = bounds

  seen = Set.new
  to_visit = [cube]
  while to_visit.any?
    current = to_visit.shift
    next if seen.include?(current)
    seen << current

    x, y, z = current
    # If we hit the bounds plus a little, we've reached air.
    if x < min_x - 5 || x > max_x + 5 ||
        y < min_y - 5 || y > max_y + 5 ||
        z < min_z - 5 || z > max_z + 5
      return true
    end

    next if cubes.include?(current)

    # If not, keep checking the neighbors
    get_points(current).each do |(x, y, z)|
      to_visit << [x, y, z]
    end
  end

  false
end


if ARGV.empty?
  # data = DATA.readlines(chomp: true)
  require 'rspec/autorun'
  RSpec.describe 'day18' do
    it 'gets points for a given coord' do
      points = get_points([0, 0, 0])
      expect(points).to eq([
        [1, 0, 0],
        [-1, 0, 0],
        [0, 1, 0],
        [0, -1, 0],
        [0, 0, 1],
        [0, 0, -1]
      ])
    end

    it 'calculates area for simple case' do
      cubes = [[1,1,1], [2,1,1]]
      expect(exposed_area(cubes)).to eq(10)
    end

    it 'works for the example input' do
      cubes = [
        [2,2,2],
        [1,2,2],
        [3,2,2],
        [2,1,2],
        [2,3,2],
        [2,2,1],
        [2,2,3],
        [2,2,4],
        [2,2,6],
        [1,2,5],
        [3,2,5],
        [2,1,5],
        [2,3,5],
      ]
      expect(exposed_area(cubes)).to eq(64)
    end

    it 'works for part 2' do
      cubes = [
        [2,2,2],
        [1,2,2],
        [3,2,2],
        [2,1,2],
        [2,3,2],
        [2,2,1],
        [2,2,3],
        [2,2,4],
        [2,2,6],
        [1,2,5],
        [3,2,5],
        [2,1,5],
        [2,3,5],
      ]
      expect(exterior_area(cubes)).to eq(58)
    end
  end
else
  data = File.readlines(ARGV.first, chomp: true)
  cubes = data
    .map { _1.split(",") }
    .map { _1.map(&:to_i) }
    .to_set
  # Part 1
  puts "Expected 4242, actual #{exposed_area(cubes)}"

  # Part 2
  # not 9409
  puts "Expected ???, actual #{exterior_area(cubes)}"
end

__END__
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
