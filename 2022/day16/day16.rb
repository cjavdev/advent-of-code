# require 'set'
# require 'byebug'

if ARGV.empty?
  data = DATA.readlines(chomp: true)
else
  data = File.readlines(ARGV[0], chomp: true)
end

ADJ = {}
VALVES = {}
data.each do |line|
  match = /Valve (?<name>[A-Z]{2}) has flow rate=(?<rate>\d+); tunnels? leads? to valves? (?<valves>.*)/.match(line)
  ADJ[match[:name]] = match[:valves].split(', ')
  VALVES[match[:name]] = match[:rate].to_i
end

# Part 1
# $cache = {}
# def max_flow(current, opened, min_left)
#   return 0 if min_left <= 0
#   key = [min_left, current, opened].join
#   return $cache[key] if $cache[key]
#   max = 0
#   step = min_left - 1
#
#   if !opened.include?(current)
#     current_opened = (opened + [current]).sort
#     val = step * VALVES[current]
#     if val != 0
#       new_max = val + max_flow(current, current_opened, step)
#       max = new_max if new_max > max
#     end
#   end
#
#   ADJ[current].each do |adj|
#     new_max = max_flow(adj, opened, step)
#     max = new_max if new_max > max
#   end
#
#   $cache[key] = max
#   max
# end
#
# p max_flow("AA", [], 30)

$cache = {}
def max_flow(current, opened, min_left, others)
  key = [min_left, current, opened, others].join
  return $cache[key] if $cache[key]

  if min_left <= 0
    return 0 if others == 0
    return max_flow("AA", opened, 26, 0)
  end

  max = 0
  step = min_left - 1

  if !opened.include?(current)
    current_opened = (opened + [current]).sort
    val = step * VALVES[current]
    if val != 0
      new_max = val + max_flow(current, current_opened, step, others)
      max = new_max if new_max > max
    end
  end

  ADJ[current].each do |adj|
    new_max = max_flow(adj, opened, step, others)
    max = new_max if new_max > max
  end

  $cache[key] = max
  max
end

# Part 1
# p max_flow("AA", [], 30)
# Part 2
p max_flow("AA", [], 26, 1)
# p max_flow("AA", [], 30, 0)


__END__
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
