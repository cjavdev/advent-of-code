puts 'Hello, World!'
input = <<~EOF
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
EOF
input = <<~EOF
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
EOF

data = input.each_line.map(&:chomp)
data = DATA.readlines.map(&:chomp)
turns,_,*n = data
turns = turns.chars

nodes = n.map do |x|
  k, a, b = x.scan(/\w+/)
  [k, [a, b]]
end.to_h

def find(k, nodes, turns)
  puts "looking at #{k}"
  cur = k
  c = 0
  while !cur.end_with?('Z')
    l, r = nodes[cur]
    d = turns[c % turns.length]
    # p [cur, d]
    if d == "R"
      cur = r
    else
      cur = l
    end
    c += 1
  end
  p c
end

paths = nodes.keys.select { |k| k.end_with?('A')  }
p paths.map{|k| find(k, nodes, turns)}.inject(&:lcm)



# cur = "AAA"
# c = 0
# while cur != "ZZZ"
#   p cur
#   l, r = nodes[cur]
#   if turns.first == "R"
#     cur = r
#   else
#     cur = l
#   end
#   c+= 1
#   turns.rotate!(1)
# end
# p c
