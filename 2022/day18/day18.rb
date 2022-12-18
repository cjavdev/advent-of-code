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
      cubes.include?(point) ? area2 : area2 + 1
    end
  end
end


if ARGV.empty?
  data = DATA.readlines(chomp: true)
  require 'rspec/autorun'
  RSpec.describe 'day18' do
    it 'gets points for a given coord' do
      points = get_points([0, 0, 0])
      expect(points).to eq([
        [0, 0, 0],
        [1, 0, 0],
        [0, 1, 0],
        [1, 1, 0],
        [0, 0, 1],
        [1, 0, 1],
        [0, 1, 1],
        [1, 1, 1],
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

end
