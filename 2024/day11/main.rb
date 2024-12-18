require 'rspec/autorun'

input = "125 17"
inputx = "41078 18 7 0 4785508 535256 8154 447"

stones = input.split(" ").map(&:to_i).each_with_object(Hash.new(0)) do |stone, h|
  h[stone] = 1
end

  def blink(stones)
  new_stones = Hash.new(0)

  stones.each do |stone, count|
    if stone == 0
      new_stones[1] += count
    elsif stone.to_s.size.even?
      new_stones[stone.to_s[...stone.to_s.size/2].to_i] += count
      new_stones[stone.to_s[stone.to_s.size/2..].to_i] += count
    else
      new_stones[stone * 2024] += count
    end
  end

  new_stones
end

6.times do
  stones = blink(stones)
  p stones
end

p stones.values.sum
