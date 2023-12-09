input = <<~INPUT
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
INPUT

data = input.each_line.map(&:chomp)
data = DATA.readlines.map(&:chomp)

turns, _, *n = data
turns = turns.chars

nodes = n.map do |node|
  name, left, right = node.scan(/\w+/)
  [name, [left, right]]
end.to_h

def find(cur, nodes, turns, &blk)
  step = 0
  while !blk.call(cur)
    if turns[step % turns.length] == "L"
      cur, _ = nodes[cur]
    else
      _, cur = nodes[cur]
    end
    step += 1
  end
  step
end

p find("AAA", nodes, turns) {|c| c == "ZZZ"}

p nodes
  .keys
  .select {|k| k.end_with?("A") }
  .map {|k| find(k, nodes, turns) {|c| c.end_with?("Z")} }
  .inject(&:lcm)
