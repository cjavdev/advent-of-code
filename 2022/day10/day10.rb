if ARGV.empty?
  data = DATA.readlines(chomp: true)
else
  data = File.readlines(ARGV[0], chomp: true)
end

x = 1
count = 0

registers = Enumerator.new do |y|
  data
    .map {_1.split(/ /)}
    .each do |(cmd, arg)|
      count += 1
      y << [count, x]
      if cmd == 'addx'
        count += 1
        y << [count, x]
      end
      x += arg.to_i
    end
end

cycle_tracker = Hash[registers.to_a]

# Part 1 with enumerator
# p Enumerator
#   .produce(20) { _1 + 40 }
#   .take(6)
#   .inject(0) {|sum, sig| sum + (cycle_tracker[sig] * sig) }

# Part 1 with range + step
p (20..240)
  .step(40)
  .inject(0) {|sum, sig| sum + (cycle_tracker[sig] * sig) }

# Part 2
cycle_tracker.each.with_index do |(cycle, sig), i|
  column = (cycle - 1) % 40
  puts if column == 0
  print column.between?(sig - 1, sig + 1) ? "#" : " "
end

__END__
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
