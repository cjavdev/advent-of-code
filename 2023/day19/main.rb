require 'rspec/autorun'
require 'byebug'
require 'set'

input = <<~INPUT
px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}
INPUT

# input = DATA.read
workflows, parts = input.split("\n\n")
workflows = workflows.split(/\n/).map do |wf|
  name, *rules = wf.split(/[{},]/)
  rules = rules.map do |rule|
    if rule.include?(':')
      condition, dest = rule.split(':')
      condition = [
        condition[0].to_sym,
        condition[1].to_sym,
        condition[2..-1].to_i
      ]
      [condition, dest.to_sym]
    else
      rule.to_sym
    end
  end
  [name.to_sym, rules]
end.to_h

# parts = parts.split(/\n/).map do |part|
#   part.gsub(/[{}]/, '').split(/,/).map do |comp|
#     var, val = comp.split('=')
#     [var, val.to_i]
#   end.to_h
# end
#
# p parts

# parts.filter_map do |part|
#   if process(part, workflows, "in")
#     p part.values.sum
#   end
# end.sum => a
# p a


def deep_dup(obj)
  Marshal.load(Marshal.dump(obj))
end

def get_ranges(workflows)
  accepted_rules = Set.new
  default_constraints = { x: [0, 4000], m: [0, 4000], a: [0, 4000], s: [0, 4000] }

  queue = [[:in, { x: [0, 4000], m: [0, 4000], a: [0, 4000], s: [0, 4000] }]]

  while queue.any?
    current = queue.shift
    k, ranges = current
    ranges = deep_dup(ranges)

    if k == :A
      accepted_rules << ranges
      next
    elsif k == :R
      next
    end


    workflows[k].each do |rule|
      if rule.is_a?(Array)
        (var, op, val), dest = rule
        new_range = ranges

        # Add a new range
        if op == :<
          if val <= default_constraints[var][0]
            next
          end

          # Set the default constraints max to the value.
          default_constraints[var][1] = val

          # Set the new state's min to the value - 1
          new_range[var][0] = val - 1
        elsif op == :>
          if val >= default_constraints[var][1]
            next
          end

          # Set the default constraints min to the value.
          default_constraints[var][0] = val

          # Set the new state's max to the value + 1
          new_range[var][1] = val + 1
        end
        queue << [dest, new_range]
      else
        queue << [rule, ranges.dup]
      end
    end
  end

  p accepted_rules
end

get_ranges(workflows)
