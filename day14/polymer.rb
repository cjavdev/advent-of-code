class Polymer
  attr_reader :template, :pairs
  def initialize(template, pairs)
    @template = Hash.new(0)
    template.chars.each_cons(2) do |pair|
      @template[pair.join] += 1
    end
    @pairs = pairs
  end

  def step
    result = []
    keys = template.keys.dup
    temp_template = Hash.new(0)
    keys.each_with_index do |key, i|
      # next if @template[key] == 0
      a, b = key.chars
      char = @pairs[key]
      v = @template[key]
      if v > 0
        temp_template[key] -= v
        temp_template[[a, char].join] += v
        temp_template[[char, b].join] += v
      end

      # PART 1
      # char = pairs[[a, b].join]
      # if i == 0
      #   result += [a, char, b]
      # else
      #   result += [char, b]
      # end
    end
    temp_template.each do |k, v|
      @template[k] += v
    end
    # @template = result.join
  end

  def score_counter
    counter = Hash.new(0)
    k, v = @template.first
    a, b = k.chars
    @template.each do |k, v|
      a, b = k.chars
      counter[a] += v
      counter[b] += v
    end
    Hash[counter.map do |k, v|
      [k, (v/2.0).ceil]
    end]
  end

  def score
    tally = score_counter.values.sort
    tally.last - tally.first
    # PART 1
    # tally = @template.chars.tally.values.sort
    # tally.last - tally.first
  end
end

if __FILE__ == $0
  template, _, *pairs = DATA.each_line.map(&:chomp)
  pairs = Hash[pairs.map {_1.split(' -> ')}]
  polymer = Polymer.new(template, pairs)
  40.times { polymer.step }
  puts polymer.score
end

__END__
HBCHSNFFVOBNOFHFOBNO

HF -> O
KF -> F
NK -> F
BN -> O
OH -> H
VC -> F
PK -> B
SO -> B
PP -> H
KO -> F
VN -> S
OS -> B
NP -> C
OV -> C
CS -> P
BH -> P
SS -> P
BB -> H
PH -> V
HN -> F
KV -> H
HC -> B
BC -> P
CK -> P
PS -> O
SH -> N
FH -> N
NN -> P
HS -> O
CB -> F
HH -> F
SB -> P
NB -> F
BO -> V
PN -> H
VP -> B
SC -> C
HB -> H
FP -> O
FC -> H
KP -> B
FB -> B
VK -> F
CV -> P
VF -> V
SP -> K
CC -> K
HV -> P
NC -> N
VH -> K
PF -> P
PB -> S
BF -> K
FF -> C
FV -> V
KS -> H
VB -> F
SV -> F
HO -> B
FN -> C
SN -> F
OB -> N
KN -> P
BV -> H
ON -> N
NF -> S
OF -> P
NV -> S
VS -> C
OO -> C
BP -> H
BK -> N
CP -> N
PC -> K
CN -> H
KB -> B
BS -> P
KK -> P
SF -> V
CO -> V
CH -> P
FO -> B
FS -> F
VO -> H
NS -> F
KC -> H
VV -> K
NO -> P
OK -> F
PO -> V
FK -> H
OP -> H
PV -> N
CF -> P
NH -> K
SK -> O
KH -> P
HP -> V
OC -> V
HK -> F
