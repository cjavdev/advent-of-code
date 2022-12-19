require 'byebug'

def blueprints(data)
  data
    .map { |line| line.split(/ |:/) }
    .map do |line|
      {
        id: line[1].to_i,
        ore_robot: line[7].to_i,
        clay_robot_ore: line[13].to_i,
        obsidian_robot_ore: line[19].to_i,
        obsidian_robot_clay: line[22].to_i,
        geode_robot_ore: line[28].to_i,
        geode_robot_obsidian: line[31].to_i,
        max_ore: [line[7].to_i, line[13].to_i, line[19].to_i, line[28].to_i].max,
        max_clay: line[22].to_i,
        max_obsidian: line[31].to_i,
      }
    end
end

SEEN = {}

def best_geodes(blueprint, ore_robots, clay_robots, obsidian_robots, geode_robots, ore, clay, obsidian, geodes, time)
  return geodes if time == 0

  key = [
    ore_robots,
    clay_robots,
    obsidian_robots,
    geode_robots,
    ore % (blueprint[:max_ore] + 1), # If we have more than max ore it doesn't make a difference for the next minute, so I cache the results the same. There's no way to spend more than the max in one step.
    clay % (blueprint[:max_clay] + 1),
    obsidian % (blueprint[:max_obsidian] + 1),
    geodes,
    time
  ]
  return SEEN[key] if SEEN.include?(key)

  max = 0

  option = best_geodes(
    blueprint,
    ore_robots,
    clay_robots,
    obsidian_robots,
    geode_robots,
    ore+ore_robots,
    clay+clay_robots,
    obsidian+obsidian_robots,
    geodes+geode_robots,
    time - 1
  )
  max = option if option > max

  # Can we buy an ore robot?
  if ore >= blueprint[:ore_robot] && ore_robots <= blueprint[:max_ore]
    option = best_geodes(
      blueprint,
      ore_robots+1,
      clay_robots,
      obsidian_robots,
      geode_robots,
      ore-blueprint[:ore_robot]+ore_robots,
      clay+clay_robots,
      obsidian+obsidian_robots,
      geodes+geode_robots,
      time - 1
    )
    max = option if option > max
  end

  # Can we buy a clay robot?
  if ore >= blueprint[:clay_robot_ore] && clay_robots <= blueprint[:max_clay]
    option = best_geodes(
      blueprint,
      ore_robots,
      clay_robots+1,
      obsidian_robots,
      geode_robots,
      ore+ore_robots-blueprint[:clay_robot_ore],
      clay+clay_robots,
      obsidian+obsidian_robots,
      geodes+geode_robots,
      time - 1
    )
    max = option if option > max
  end

  # Can we buy an obsidian robot?
  if ore >= blueprint[:obsidian_robot_ore] && clay >= blueprint[:obsidian_robot_clay] && obsidian_robots <= blueprint[:max_obsidian]
    option = best_geodes(
      blueprint,
      ore_robots,
      clay_robots,
      obsidian_robots+1,
      geode_robots,
      ore+ore_robots-blueprint[:obsidian_robot_ore],
      clay+clay_robots-blueprint[:obsidian_robot_clay],
      obsidian+obsidian_robots,
      geodes+geode_robots,
      time - 1
    )
    max = option if option > max
  end

  # Can we buy a geode robot?
  if ore >= blueprint[:geode_robot_ore] && obsidian >= blueprint[:geode_robot_obsidian]
    option = best_geodes(
      blueprint,
      ore_robots,
      clay_robots,
      obsidian_robots,
      geode_robots+1,
      ore+ore_robots-blueprint[:geode_robot_ore],
      clay+clay_robots,
      obsidian+obsidian_robots-blueprint[:geode_robot_obsidian],
      geodes+geode_robots,
      time - 1
    )
    max = option if option > max
  end

  SEEN[key] = max
  max
end

if ARGV.empty?
  data = DATA.readlines(chomp: true)
  prints = blueprints(data)
  puts "Expected: 56 got #{ best_geodes(prints.first, 1, 0, 0, 0, 0, 0, 0, 0, 24) }"
else
  data = File.readlines(ARGV.first, chomp: true)
  # Part 1
  # ans = blueprints(data).inject(0) do |sum, blueprint|
  #   SEEN.clear
  #   sum + (best_geodes(blueprint, 1, 0, 0, 0, 0, 0, 0, 0, 24) * blueprint[:id])
  # end
  # p ans
  # Part 2
  ans = blueprints(data).take(3).inject(1) do |prod, blueprint|
    SEEN.clear
    p prod * best_geodes(blueprint, 1, 0, 0, 0, 0, 0, 0, 0, 32)
  end
  p ans
end

__END__
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
