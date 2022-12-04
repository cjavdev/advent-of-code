require 'set'

if ARGV.any?
  data = File.readlines(ARGV[0])
else
  data = DATA.readlines
end

results = data
  .map(&:chomp)
  .map {_1.split(/[,-]/) }
  .map {_1.map(&:to_i) }
  .map {_1.each_slice(2).to_a }
  .map {|a| a.map {Range.new(*_1).to_set}}
  .reduce(0) {|count, (a, b)| a.intersect?(b) ? count + 1 : count }
  # part 1 .reduce(0) {|count, (a, b)| a.subset?(b) || b.subset?(a) ? count + 1 : count }

p results

__END__
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
