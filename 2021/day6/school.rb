require 'byebug'
# School of lanternfish part 1
class School
  attr_reader :ages

  def initialize(ages)
    @ages = ages
  end

  def pass_days(n)
    n.times { tick }
  end

  def tick
    births = ages.count(0)
    ages.map! {_1 == 0 ? 6 : _1 - 1}
    @ages += [8] * births
  end
end

# School of lanternfish part 2
class NewSchool
  attr_reader :ages

  def initialize(ages)
    @ages = {
      0 => ages.count(0),
      1 => ages.count(1),
      2 => ages.count(2),
      3 => ages.count(3),
      4 => ages.count(4),
      5 => ages.count(5),
      6 => ages.count(6),
      7 => 0,
      8 => 0
    }
  end

  def pass_days(n)
    n.times { tick }
  end

  def tick
    births = ages[0]
    (0..8).each { |i| ages[i] = ages[i+1] }
    ages[6] += births
    ages[8] = births
  end

  def size
    @ages.values.reduce(:+)
  end
end

if __FILE__ == $0
  ages = File.read(ARGV.first).split(",").map(&:to_i)
  school = NewSchool.new(ages)
  school.pass_days(256)
  puts school.size
end
