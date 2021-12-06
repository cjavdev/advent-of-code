require 'byebug'

class OceanFloor
  attr_reader :lines, :rows, :columns

  def self.parse_lines(lines)
    l = lines.map do |line|
      line.split('->').map do |pair|
        pair.split(',').map(&:to_i)
      end
    end
    new(l)
  end

  def initialize(lines)
    @lines = lines
    max = @lines.flatten.max + 1
    @rows = Array.new(max) { Array.new(max, 0) }
    @columns = @rows.transpose
  end

  def []=(x, y, value)
    rows[x][y] = value
    columns[y][x] = value
  end

  def [](x, y)
    rows[x][y]
  end

  def to_s
    columns.map { |row| row.join('  ') }.join("\n")
  end

  def overlaps
    rows.flatten.count {_1 > 1}
  end

  def draw_lines
    lines.each do |(x1, y1), (x2, y2)|
      puts [x1, y1, x2, y2].join(',')
      if x1 != x2 && y1 != y2
        puts "Next: " + [x1, y1, x2, y2].join(',')
        next
      end

      [x1, x2].min.upto([x1, x2].max) do |x|
        [y1, y2].min.upto([y1, y2].max) do |y|
          self[x, y] += 1
        end
      end
    end
  end
end

if __FILE__ == $0
  lines = File.readlines(ARGV.first)
  floor = OceanFloor.parse_lines(lines)
  floor.draw_lines
  puts floor
  puts lines
  puts floor.overlaps
end
