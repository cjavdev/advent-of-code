require 'rspec/autorun'

input = <<~INPUT
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
INPUT

def expand(record)
  ([record] * 5).join("?")
end

def parse2(line)
  record, sizes = line.split(' ')
  sizes = sizes.split(',').map(&:to_i) * 5

  record = "#{expand(record)}.".gsub(/\.+/, '.')
  [record, sizes]
end

def parse(line)
  record, sizes = line.split(' ')
  sizes = sizes.split(',').map(&:to_i)
  record = "#{record}."
  [record, sizes]
end

def count(record, sizes, group_size = 0, cache = {})
  key = [record, sizes, group_size]

  if cache[key]
    return cache[key]
  end

  if sizes.any? { |s| s - group_size > record.length }
    return cache[key] = 0
  end

  if sizes.empty?
    if !record.include?("#")
      return cache[key] = 1
    else
      return cache[key] = 0
    end
  end

  current, *rest = record.chars
  s = sizes.first

  case [current, group_size]
  in ['?', _]
    # with both the `.` and the `#` instead of the question mark
    return cache[key] = count('#' + rest.join, sizes, group_size, cache) + count('.' + rest.join, sizes, group_size, cache)
  in ['#', _]
    # keep moving forward through the group of brokens #
    return cache[key] = count(rest.join, sizes, group_size + 1, cache)
  in ['.', ^s]
    # If we found the end of the group because group_size == sizes.first
    return cache[key] = count(rest.join, sizes[1..], 0, cache)
  in ['.', (1..)]
    # Invalid group size / not enough #s
    return cache[key] = 0
  in ['.', 0]
    # no-op - keep moving forward
    return cache[key] = count(rest.join, sizes, 0, cache)
  end
end

data = input.each_line
# data = DATA.readlines

puts "Record Count: #{data.count}"

counter = 0
data.inject(0) do |sum, line|
  if counter % 5 == 0
    puts counter
  end
  counter += 1

  record, sizes = parse2(line)
  sum + count(record, sizes)
end => r

puts "Part 2: #{r}"

describe 'count' do
  it 'parses as expected' do
    expect(parse2("???.### 1,1,3")).to eq([
      "???.###????.###????.###????.###????.###.",
      [1,1,3,1,1,3,1,1,3,1,1,3,1,1,3]
    ])
  end

  it 'works on basic cases' do
    cases = [
      ["# 1", 1],
      [".# 1", 1],
      ["#. 1", 1],
      ["#. 2", 0],
      ["???.### 1,1,3", 1],
      [".??..??...?##. 1,1,3", 4],
      ["?#?#?#?#?#?#?#? 1,3,1,6", 1],
      ["????.#...#... 4,1,1", 1],
      ["????.######..#####. 1,6,5", 4],
      ["?###???????? 3,2,1", 10],
    ]

    cases.each do |input, expected|
      expect(count(*parse(input))).to eq(expected), -> { p input }
    end
  end
end


