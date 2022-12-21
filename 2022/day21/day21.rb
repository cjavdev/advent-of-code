if ARGV.empty?
  data = DATA.readlines(chomp:true)
else
  data = File.readlines('input', chomp: true)
end

solved = {}
expressions = {}

data
  .each do |line|
    name, v = line.split(": ")
    if name == 'humn'
      # No op
    elsif v.include?(' ')
      a, op, b = v.split
      op = :== if name == "root"
      expressions[name] = [a, op.to_sym, b]
    else
      solved[name] = v.to_i
    end
  end

15.times do
  expressions.each do |k, (a, op, b)|
    if !a.is_a?(Integer) && solved.has_key?(a)
      a = solved[a]
    end
    if !b.is_a?(Integer) && solved.has_key?(b)
      b = solved[b]
    end
    if a.is_a?(Integer) && b.is_a?(Integer)
      solved[k] = a.send(op, b)
      expressions.delete(k)
    else
      expressions[k] = [a, op, b]
    end
  end
end

expressions["humn"] = ["x"]

def get(a, expressions)
  if a.is_a?(String) && expressions.has_key?(a)
    x = expressions[a]
    expressions.delete(a)
    x
  elsif a.is_a?(Array)
    a.map {get(_1, expressions)}
  else
    a
  end
end

15.times do
  expressions.each do |k, v|
    v = v.map do |a|
      get(a, expressions)
    end
    expressions[k] = v
  end
end

def rp(x)
  if x.is_a?(Array)
    print "("
    x.each{rp(_1)}
    print ")"
  else
    print x.to_s
  end
end

rp(expressions['root'])
puts solved['root']

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
