require 'rspec/autorun'
require 'byebug'

input = <<~INPUT
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
INPUT

def clean_sym(s)
  # Ensure we always start and end with a dot.
  ".#{s.gsub(/^\.+|\.+$/, '')}."
end

def all_options(sym)
  return [""] if sym.empty?

  options = []
  head, *tail = sym.chars

  if head == "?"
    all_options(tail.join).each do |o|
      options << "#" + o
      options << "." + o
    end
  else
    all_options(tail.join).each do |o|
      options << head + o
    end
  end

  options
end

def count2(expanded, sizes)
  options = all_options(expanded)
  options.count do |o|
    sizes == o.split('.').reject{_1==""}.map(&:size)
  end
end

def count3(sym, sizes, group_count=0, cache={})
  # p [sym, sizes, group_count]

  key = [sym, sizes, group_count]
  if cache[key]
    return cache[key]
  end

  if sizes.any? { _1 - group_count > sym.size }
    return cache[key] = 0
  end

  if sizes.empty?
    if !sym.include?("#")
      return cache[key] = 1
    else
      return cache[key] = 0
    end
  end

  head, *tail = sym.chars
  case [head, group_count]
  in ["?", *]
    return cache[key] = count3("#" + tail.join, sizes, group_count, cache) + count3("." + tail.join, sizes, group_count, cache)
  in ["#", *]
    # We're inside a group, keep counting and increment group count.
    return cache[key] = count3(tail.join, sizes, group_count + 1, cache)
  in [".", (1..)]
    # We just exited a group, and are done with this section of the string.
    if group_count == sizes.first
      return cache[key] = count3(tail.join, sizes[1..], 0, cache)
    else
      # If group count is greater than 0 and we're on a dot, this state is invalid
      return cache[key] = 0
    end
  in [".", 0]
    return cache[key] = count3(tail.join, sizes, 0, cache)
  end

  cache[key] = 0
end

data = input.each_line
data = DATA.readlines

records = data.map do |line|
  line.split(' ') => sym, n
  n = n.split(',').map(&:to_i)
  [sym, n]
end

# Part 1
puts "Working on Part 1a"
# records.inject(0) do |sum, (sym, n)|
#   sum + count2(clean_sym(sym), n)
# end => r
#
# puts "Part 1a: #{r}"

cache = {}
records.inject(0) do |sum, (sym, n)|
  sum + count3(clean_sym(sym), n, 0, cache)
end => r
puts "Part 1b: #{r}"

# Part 2
cache = {}
records = records.map do |sym, n|
  [([sym] * 5).join("?"), n * 5]
end.inject(0) do |sum, (sym, n)|
  sum + count3(clean_sym(sym), n, 0, cache)
end => r
puts "Part 2: #{r}"

describe 'count' do
  it 'works for basic cases' do
    expect(count2(clean_sym('#.#'), [1, 1])).to eq(1)
    expect(count2(clean_sym('#..'), [1, 1])).to eq(0)
    expect(count2(clean_sym('#.#.'), [1, 1])).to eq(1)
    expect(count2(clean_sym('.??..??...?##.'), [1, 1, 3])).to eq(4)
    expect(count2(clean_sym('????.#...#...'), [4, 1, 1])).to eq(1)
    expect(count2(clean_sym('????.######..#####.'), [1, 6, 5])).to eq(4)
    expect(count2(clean_sym(""), [2])).to eq(0)
    expect(count2(".???.", [2])).to eq(2)
    expect(count2(clean_sym('.???'), [2])).to eq(2)
    expect(count2(clean_sym('?###????'), [3, 2])).to eq(2)
    expect(count2(clean_sym('?###?????'), [3, 2])).to eq(3)
    expect(count2(clean_sym('?###????????'), [3, 2, 1])).to eq(10)
    expect(count2(clean_sym('???'), [1, 1])).to eq(1)
    expect(count2(clean_sym('???.###'), [1, 1, 3])).to eq(1)
    expect(count2(clean_sym('?#?#?#?#?#?#?#?'), [1, 3, 1, 6])).to eq(1)
    expect(count2(clean_sym("?#??..?#??##?????."), [1, 11])).to eq(1)

    expect(count3(clean_sym('#.#'), [1, 1])).to eq(1)
    expect(count3(clean_sym('#..'), [1, 1])).to eq(0)
    expect(count3(clean_sym('#.#.'), [1, 1])).to eq(1)
    expect(count3(clean_sym('.??..??...?##.'), [1, 1, 3])).to eq(4)
    expect(count3(clean_sym('????.#...#...'), [4, 1, 1])).to eq(1)
    expect(count3(clean_sym('????.######..#####.'), [1, 6, 5])).to eq(4)
    expect(count3(clean_sym(""), [2])).to eq(0)
    expect(count3(".???.", [2])).to eq(2)
    expect(count3(clean_sym('.???'), [2])).to eq(2)
    expect(count3(clean_sym('?###????'), [3, 2])).to eq(2)
    expect(count3(clean_sym('?###?????'), [3, 2])).to eq(3)
    expect(count3(clean_sym('?###????????'), [3, 2, 1])).to eq(10)
    expect(count3(clean_sym('???'), [1, 1])).to eq(1)
    expect(count3(clean_sym('???.###'), [1, 1, 3])).to eq(1)
    expect(count3(clean_sym('?#?#?#?#?#?#?#?'), [1, 3, 1, 6])).to eq(1)
    expect(count3(clean_sym("?#??..?#??##?????."), [1, 11])).to eq(1)
  end
end
