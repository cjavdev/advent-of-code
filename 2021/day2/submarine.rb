class Submarine
  attr_reader :horizontal_position, :depth

  def initialize(&blk)
    @horizontal_position = 0
    @depth = 0

    if block_given?
      instance_eval(&blk)
    end
  end

  def forward(n)
    @horizontal_position += n
  end

  def down(n)
    @depth += n
  end

  def up(n)
    @depth -= n
  end

  def location
    horizontal_position * depth
  end
end

if __FILE__ == $0
  # Part 1
  commands = File.read(ARGV.first)
  submarine = Submarine.new do
    eval(commands)
  end
  puts submarine.location
end
