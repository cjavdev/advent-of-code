races = [[7, 9], [15, 40], [30, 200]]
races = [[71530, 940200]]

races.inject(1) do |acc, (t, record)|
  c = 0
  t.times do |i|
    if (i * (t-i)) > record
      c += 1
    end
  end
  acc * c
end => r
p r
