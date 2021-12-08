class Segments
  def self.parse(input)
    patterns, output = input.split('|').map {|part| part.split(' ').map {_1.chars.sort.join}}
    Segments.new(patterns, output)
  end

  attr_reader :patterns, :output

  def initialize(patterns, output)
    @patterns = patterns
    @output = output
    @mapping = [
      zero,
      one,
      two,
      three,
      four,
      five,
      six,
      seven,
      eight,
      nine
    ]
  end

  def output_number
    output.map do |m|
      @mapping.find_index(m).to_s
    end.join.to_i
  end

  #  aaaa
  # b    c
  # b    c
  #  dddd
  # e    f
  # e    f
  #  gggg
  def top
    seven.chars.reject {[top_right, bottom_right].include?(_1)}[0]
  end

  def middle
    (eight.chars - zero.chars).first
  end

  def bottom

  end

  def top_left

  end

  def top_right
    one.chars.find {_1 != bottom_right}
  end

  def bottom_left
    (eight.chars - nine.chars).first
  end

  def bottom_right
    freq.find {|k, v| v == 9}[0]
  end

  def freq
    @freq ||= begin
      counts = Hash.new(0)
      patterns.each do |pat|
        pat.chars.each do |c|
          counts[c] += 1
        end
      end
      counts
    end
  end

  def to_s
    puts " #{([top] * 4).join} "
    puts "#{top_left}    #{top_right}"
    puts "#{top_left}    #{top_right}"
    puts " #{([middle] * 4).join} "
    puts "#{bottom_left}    #{bottom_right}"
    puts "#{bottom_left}    #{bottom_right}"
    puts " #{([bottom] * 4).join} "
  end

  def zero
    possible = patterns.select {_1.length == 6}
    possible.find do |possibility|
      possibility != six && (possibility.chars - four.chars).length == 3
    end
  end

  def one
    @one ||= patterns.find {_1.length == 2}
  end

  def two
    possible = patterns.select {_1.length == 5}
    possible.find do |possibility|
      possibility.chars.include?(bottom_left)
    end
  end

  def three
    possible = patterns.select {_1.length == 5}
    possible.find do |possibility|
      possibility != five && !possibility.chars.include?(bottom_left)
    end
  end

  def four
    patterns.find {_1.length == 4}
  end

  def five
    (six.chars - [bottom_left]).join
  end

  def six
    possible = patterns.select {_1.length == 6}
    possible.find do |possibility|
      !possibility.chars.include?(top_right)
    end
  end

  def seven
    patterns.find {_1.length == 3}
  end

  def eight
    patterns.find {_1.length == 7}
  end

  def nine
    possible = patterns.select {_1.length == 6}
    possible.find do |possibility|
      possibility != six && possibility != zero
    end
  end

  def output_simple_digets
    output.count { [2, 3, 4, 7].include?(_1.length) }
  end
end

if __FILE__ == $0
  d = 0
  File.readlines(ARGV.first).each do |line|
    puts line
    d += Segments.parse(line).output_number
  end
  puts d
end
