def h(input)
  input
    .chars
    .map(&:ord)
    .inject(0) do |c, ascii|
      c += ascii
      c *= 17
      c % 256
    end
end

examples = [
  ["rn=1", 30],
  ["cm-", 253],
  ["qp=3", 97],
  ["cm=2", 47],
  ["qp-", 14],
  ["pc=4", 180],
  ["ot=9", 9],
  ["ab=5", 197],
  ["pc-", 48],
  ["pc=6", 214],
  ["ot=7", 231],
]

# data = "your input"
# instructions = data.split(",")

instructions = examples.map(&:first)

# Part 1
# instructions.map do |ins|
#   h(ins)
# end.sum => r
# p r

boxes = Hash.new { |h, k| h[k] = [] }

def parse(ins)
  *label, a, b = ins.chars
  if b == "-"
    [ins[0...-1], "-", nil]
  else
    [ins[0...-2], a, b.to_i]
  end
end

instructions
  .map {|ins| parse(ins)}
  .each do |label, ins, focal|
    lenses = boxes[h(label)]
    if ins == "-"
      lenses.delete_if {_1.first == label}
    else
      if lense = lenses.find {|(l, f)| l == label}
        lense[1] = focal
      else
        lenses << [label, focal]
      end
    end
  end

sum = 0
boxes.each do |k, lenses|
  lenses.each_with_index do |(label, focal), slot|
    sum += [k + 1, slot + 1, focal].inject(&:*)
  end
end
p sum

