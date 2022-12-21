if ARGV.empty?
  data = DATA.readlines(chomp: true)
else
  data = File.readlines(ARGV[0], chomp: true)
end

solved = {}
expressions = {}

data.each do |line|
  name, expression = line.split(': ')
  if name == 'humn' # Part 2
    # no op
  elsif expression.include?(' ')
    left, op, right = expression.split
    # Part 2
    op = "=".to_sym if name == 'root'
    expressions[name] = [left, op.to_sym, right]
  else
    solved[name] = expression.to_i
  end
end

r = 0
while r < 15
  r += 1
  expressions.each do |name, expression|
    left, op, right = expression
    if !left.is_a?(Integer) && solved.has_key?(left)
      left = solved[left]
    end
    if !right.is_a?(Integer) && solved.has_key?(right)
      right = solved[right]
    end
    if left.is_a?(Integer) && right.is_a?(Integer)
      # solved[name] = left + right
      solved[name] = left.send(op, right)
      expressions.delete(name)
    else
      expressions[name] = [left, op, right]
    end
  end
end

def get(n, expressions)
  if n == 'humn'
    'x'
  elsif n.is_a?(String) && expressions.has_key?(n)
    x = expressions[n]
    expressions.delete(n)
    x
  elsif n.is_a?(Array)
    n.map { |x| get(x, expressions) }
  else
    n
  end
end

10.times do
  expressions.each do |k, v|
    expressions[k] = v.map do |v|
      get(v, expressions)
    end
  end
end

def print_eq(eq)
  if eq.is_a?(Array)
    print "("
    eq.map { |x| print_eq(x) }
    print ")"
  else
    print eq.to_s
  end
end

print_eq(expressions['root'])


# PART 1
# data.each do |line|
#   name, expression = line.split(': ')
#   if expression.include?(' ')
#     left, op, right = expression.split
#     expressions[name] = [left, op.to_sym, right]
#   else
#     solved[name] = expression.to_i
#   end
# end
#
# while expressions.any?
#   expressions.each do |name, expression|
#     left, op, right = expression
#     if !left.is_a?(Integer) && solved.has_key?(left)
#       left = solved[left]
#     end
#
#     if !right.is_a?(Integer) && solved.has_key?(right)
#       right = solved[right]
#     end
#
#     if left.is_a?(Integer) && right.is_a?(Integer)
#       # solved[name] = left + right
#       solved[name] = left.send(op, right)
#       expressions.delete(name)
#     else
#       expressions[name] = [left, op, right]
#     end
#   end
# end



__END__
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32

