input = <<~INPUT
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
INPUT

input = File.open("2024/day07/input").read

equations = input
  .split("\n")
  .map do |line|
    total, rest = line.split(": ")
    [total.to_i, rest.split(" ").map(&:to_i)]
  end

class Integer
  def concat(other)
    (to_s + other.to_s).to_i
  end
end

def works?(total, rest)
  [:+, :*, :concat].repeated_permutation(rest.length - 1).each do |ops|
    result = rest[0]
    rest[1..].each_with_index do |perm, i|
      result = result.send(ops[i], perm)
    end
    return true if result == total
  end

  false
end

sum = 0
equations.each do |total, rest|
  if works?(total, rest)
    sum += total
  end
end
p sum
