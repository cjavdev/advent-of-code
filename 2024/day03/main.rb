# input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
input = File.open("./2024/day03/input").read

enabled = true
sum = 0

input
  .scan(/(?:mul\(\d{1,3},\d{1,3}\)|do\(\))|don't\(\)/)
  .each do |instruction|
    p instruction
    case instruction
    in /mul\(\d{1,3},\d{1,3}\)/
      a, b = instruction.scan(/\d{1,3}/).map(&:to_i)
      sum += a * b if enabled
    in "do()"
      enabled = true
    in "don't()"
      enabled = false
    end
  end

p sum
