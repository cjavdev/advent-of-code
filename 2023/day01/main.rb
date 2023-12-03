example = <<~IN
  1abc2
  pqr3stu8vwx
  a1b2c3d4e5f
  treb7uchet
IN
example2 = <<~IN
  two1nine
  eightwothree
  abcone2threexyz
  xtwone3four
  4nineeightseven2
  zoneight234
  7pqrstsixteen
IN

WORD_TO_NUMBER = {
  'one' => '1',
  'two' => '2',
  'three' => '3',
  'four' => '4',
  'five' => '5',
  'six' => '6',
  'seven' => '7',
  'eight' => '8',
  'nine' => '9',
  '1' => '1',
  '2' => '2',
  '3' => '3',
  '4' => '4',
  '5' => '5',
  '6' => '6',
  '7' => '7',
  '8' => '8',
  '9' => '9',
  '0' => '0',
}

def pair_in_line(line)
  m = line.match(/(#{WORD_TO_NUMBER.keys.join("|")})/, 0)
  head = WORD_TO_NUMBER[m[0]]

  m2 = line.reverse.match(/(#{WORD_TO_NUMBER.keys.map(&:reverse).join("|")})/, 0)
  tail = WORD_TO_NUMBER[m2[0].reverse]
  [head, tail]
end

# p a = pair_in_line('abc2one'); a == ['2', '1']; a
# p pair_in_line('abcone2threexyz')# == ['1', '3']
# p pair_in_line('pqr3stu8vwx') == ['3', '8']
# p pair_in_line('poneqr3stu8vwx') == ['1', '8']
# p pair_in_line('peightqr3stu8vwx') == ['8', '8']
#

def find_pair_in_line(line)
  # iterate over the groups of characters
  # starting with the first
  [find_first(line), find_last(line)]
end

def find_first(line)
  chars = line.chars
  0.upto(chars.size) do |i|
    return $& if chars[i] =~ /\d/
    3.times do |j|
      word = chars[i...i+3+j].join
      if WORD_TO_NUMBER[word]
        return WORD_TO_NUMBER[word]
      end
    end
  end
end

def find_last(line)
  chars = line.chars
  chars.size.downto(0) do |i|
    if chars[i] =~ /\d/
      return $&
    end
    3.times do |j|
      word = chars[i-3-j...i]&.join
      if WORD_TO_NUMBER[word]
        return WORD_TO_NUMBER[word]
      end
    end
  end
end

r = DATA.readlines.reduce(0) do |s, line|
  pair = pair_in_line(line)
  pair2 = find_pair_in_line(line)
  if pair.join != pair2.join
    p line
    p pair
  end
  s + pair.join.to_i
end
p r

# result = DATA.readlines.map do |line|
#   line.scan(/\d/)
# end.reduce(0) do |sum, (head, *middle, tail)|
#   sum + (head + (tail || head)).to_i
# end
# p result
