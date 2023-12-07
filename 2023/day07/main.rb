puts 'Hello, World!'
input = <<~INPUT
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
INPUT

data = input.each_line
data = DATA.readlines

class Hand
  include Comparable
  attr_reader :cards, :name, :bid

  def self.parse(line)
    line.split(' ') => c,b
    cards = c.chars.map do |ch|
      {
        "T" => 10,
        "J" => 1,
        "Q" => 12,
        "K" => 13,
        "A" => 14,
      }[ch] || ch.to_i
    end

    new(cards, c, b.to_i)
  end

  def initialize(cards,name, bid)
    @cards = cards
    @bid = bid
    @name = name
  end

  def <=>(other)
    [tv, cards] <=> [other.tv, other.cards]
  end

  def tv
    non_j = cards.select {|c| c != 1}
    j_count = cards.count(1)

    d = non_j.inject(Hash.new{|h,k| h[k] = 0}) do |h, c|
      h[c] += 1
      h
    end

    if d.length == 1
      5
    elsif d.values.any? {|v| v == 4}
      4 + j_count
    elsif d.values.any? {|v| v == 3} && d.values.any? {|v| v == 2}
      3.5
    elsif d.values.any? {|v| v == 3}
      3 + j_count
    elsif d.values.count {|v| v == 2} == 2
      2.5 + j_count
    elsif d.values.count {|v| v == 2} == 1
      2 + j_count
    else
      j_count == 5 ? j_count : 1 + j_count
    end
  end
end

hands = data.map do |line|
  Hand.parse(line)
end

hs = hands.sort
hs.each_with_index.map do |h, i|
  p [
    h.name,
    h.bid,
    i + 1,
    h.tv
  ]
  h.bid * (i+1)
end => r
p r.sum
