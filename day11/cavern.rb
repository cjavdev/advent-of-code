require 'byebug'
class Cavern
  attr_reader :energy_levels, :flash_count
  def initialize(energy_levels)
    @energy_levels = energy_levels
    @flash_count = 0
  end

  def pass_days(n)
    n.times { tick }
  end

  def first_full_flash
    i = 0
    while i < 500
      i += 1
      tick
      puts i
      return i if full_flash?
    end
  end

  def full_flash?
    @energy_levels.all? {|r| r.all?{|e| e == 0}}
  end

  def tick
    @flashed = []
    @energy_levels.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        @energy_levels[i][j] += 1
      end
    end

    @energy_levels.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if @energy_levels[i][j] > 9
          flash([i, j])
        end
      end
    end

    @energy_levels.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if @energy_levels[i][j] > 9
          @energy_levels[i][j] = 0
        end
      end
    end
    @flash_count += @energy_levels.flatten.count(0)
  end

  def to_s
    @energy_levels.map do |row|
      row.map {|c| c}.join
    end
  end

  def flash((i, j))
    return if @flashed.include?([i, j])
    @flashed << [i, j]
    neighbors([i, j]).each do |(x, y)|
      @energy_levels[x][y] += 1
      if @energy_levels[x][y] > 9
        flash([x, y])
      end
    end
  end

  def neighbors((i, j))
    [
      [i - 1, j - 1],
      [i - 1, j],
      [i - 1, j + 1],
      [i, j - 1],
      [i, j],
      [i, j + 1],
      [i + 1, j],
      [i + 1, j - 1],
      [i + 1, j + 1],
    ].select do |(x, y)|
      x.between?(0, @energy_levels.length - 1) &&
        y.between?(0, @energy_levels[0].length - 1)
    end
  end
end

if __FILE__ == $0
  energy_levels = DATA.each_line.map {|l| l.chomp.chars.map(&:to_i)}
  cavern = Cavern.new(energy_levels)
  # cavern.pass_days(100)
  puts cavern.first_full_flash
  puts cavern.to_s
end

__END__
4738615556
6744423741
2812868827
8844365624
4546674266
4518674278
7457237431
4524873247
3153341314
3721414667
