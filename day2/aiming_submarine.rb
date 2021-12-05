class AimingSubmarine
  attr_reader :aim, :depth, :horizontal_position

  def initialize(&blk)
    @aim = 0
    @horizontal_position = 0
    @depth = 0

    if block_given?
      instance_eval(&blk)
    end
  end

  def forward(n)
    @horizontal_position += n
    @depth += (aim * n)
  end

  def down(n)
    @aim += n
  end

  def up(n)
    @aim -= n
  end

  def location
    horizontal_position * depth
  end
end

if __FILE__ == $0
  # Part 2
  commands = File.read(ARGV.first)
  submarine = AimingSubmarine.new do
    eval(commands)
  end
  puts submarine.location
end
