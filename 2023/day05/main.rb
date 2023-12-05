require 'set'
require 'byebug'
input = <<~INPUT
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
INPUT
input = DATA.read

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def intersection(other)
    raise ArgumentError, 'value must be a Range' unless other.kind_of?(Range)

    my_min, my_max = first, exclude_end? ? max : last
    other_min, other_max = other.first, other.exclude_end? ? other.max : other.last

    new_min = self === other_min ? other_min : other === my_min ? my_min : nil
    new_max = self === other_max ? other_max : other === my_max ? my_max : nil

    new_min && new_max ? new_min..new_max : nil
  end

  alias_method :&, :intersection
end

s, *maps = input.split(/\n\n/)
_, *seeds = s.split.map(&:to_i)

maps = maps.map do|m|
  label, *rows = m.split(/\n/)
  rows.map {_1.split.map(&:to_i)}
end

maps = maps.map do |m|
  m2 = m.map do |dest, src, len|
    [
      src,
      src + len - 1,
      dest - src
    ]
  end.sort

  if m2[0][0] != 0
    m2.unshift([0, m2[0][0] - 1, 0])
  else
    m2
  end
end

maps = maps.map do |m|
  src_end = m[-1][1]
  end_cap = [
    src_end + 1,
    src_end + 1_000_000_000_000,
    0
  ]
  m + [end_cap]
end

def convert(page, seed_range)
  page.filter_map do |src_start, src_end, diff|
    if seed_range.overlaps?(src_start...src_end)
      intersection = seed_range & (src_start...src_end)
      rng_start = intersection.begin + diff
      rng_end = intersection.end + diff
      (rng_start..rng_end)
    end
  end
end

current_ranges = Array.new(8) { Set.new }
seeds.each_slice(2).map do |seed_start, len|
  seed_range = (seed_start...seed_start + len)
  current_ranges[0] << seed_range

  maps.each_with_index do |m, i|
    current_ranges[i].each do |current_range|
      current_ranges[i + 1] += convert(m, current_range)
    end
  end
end

p current_ranges.last.map(&:min).min

# PART 1
# def find(page, target)
#   page.each do |ds, ss, len|
#     if target >= ss && target < ss + len
#       return ds + (target - ss)
#     end
#   end
#   target
# end
#
# seeds.map do |seed|
#   s = seed
#   maps.each do |m|
#     s = find(m, s)
#   end
#   s
# end => r
#
# p r.min
