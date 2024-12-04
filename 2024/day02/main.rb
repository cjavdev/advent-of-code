input = <<~INPUT
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
INPUT

input = File.read('input')

records = input
  .split("\n")
  .map(&:split)
  .map {_1.map(&:to_i)}

def safe?(record)
  inc = record
    .each_cons(2)
    .all? {|a, b| a < b}
  dec = record
    .each_cons(2)
    .all? {|a, b| a > b}
  delta = record
    .each_cons(2)
    .all? {|a, b| (a - b).abs.between?(1,3)}

  (inc || dec ) && delta
end

def safe2?(record)
  return true if safe?(record)

  record.size.times do |i|
    return true if safe?(record[...i] + record[i+1..])
  end

  false
end

c = records.count do |record|
  p safe2?(record)
end
puts c

a = [0,1,2,3,4,5,6,7,8,9]
5.times do |i|
  p a[...i] + a[i+1..]
end