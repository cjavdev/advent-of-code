puts 'Hello, World!'
input = <<~INPUT
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
INPUT

data = input.each_line
data = DATA.readlines
stats = data.map{_1.split.map(&:to_i)}

def predict(stat)
  cur = stat
  layers = [cur]
  until cur.all?(&:zero?)
    cur = cur.each_cons(2).map do |a, b|
      b - a
    end
    layers.unshift cur
  end

  layers.each_cons(2) do |(d1, *, d2), pr|
    p1, *, p2 = pr
    pr.unshift(p1 - d1)
    pr.push(p2 + d2)
  end
  layers.last
end

stats.map do |stat|
  a, *, b = predict(stat)
  a
rescue => e
  puts "failed"
  p stat
  p e
end => r
p r.sum
