require 'byebug'

def parse_input(input)
  input
    .map(&:chomp)
    .map(&:chars)
    .map {_1.map(&:to_i) }
end

def check_visibility(rows, i, j)
  height = rows[i][j]
  row = rows[i]
  col = rows.transpose[j]

  return 1 if i == 0 || j == 0 || i == rows.size - 1 || j == rows.first.size - 1
  return 1 if height > row[0..j-1].max
  return 1 if height > row[j+1..-1].max
  return 1 if height > col[0..i-1].max
  return 1 if height > col[i+1..-1].max
  0
end

def scenic_score(rows, i, j)
  height = rows[i][j]
  row = rows[i]
  col = rows.transpose[j]

  score = 0
  scores = []

  (j-1).downto(0).each do |k|
    score += 1
    break if row[k] >= height
  end
  scores << score

  score = 0
  (j+1...row.size).each do |k|
    score += 1
    break if row[k] >= height
  end
  scores << score

  score = 0
  (i-1).downto(0).each do |k|
    score += 1
    break if col[k] >= height
  end
  scores << score

  score = 0
  (i+1...col.size).each do |k|
    score += 1
    break if col[k] >= height
  end

  scores << score
  scores.inject(:*)
end

def visibility(rows)
  i, j = rows.size, rows.first.size
  i.times.flat_map do |i|
    j.times.flat_map do |j|
      check_visibility(rows, i, j)
    end
  end.sum
end

def most_scenic(rows)
  i, j = rows.size, rows.first.size
  i.times.flat_map do |i|
    j.times.flat_map do |j|
      scenic_score(rows, i, j)
    end
  end.max
end


if ARGV.empty?
  require 'rspec/autorun'

  RSpec.describe 'day08' do
    before(:all) do
      @data = DATA.readlines
    end

    it 'scenic score' do
      trees = parse_input(@data)
      expect(scenic_score(trees, 0, 0)).to eq(0)
      expect(scenic_score(trees, 1, 2)).to eq(4)
      expect(scenic_score(trees, 3, 2)).to eq(8)

      expect(most_scenic(trees)).to eq(8)
    end

    it 'check visibility works' do
      trees = parse_input(@data)
      expect(check_visibility(trees, 0, 0)).to eq(1)
      expect(check_visibility(trees, 1, 1)).to eq(1)
      expect(check_visibility(trees, 1, 2)).to eq(1)
    end

    it 'works for the example case' do
      trees = parse_input(@data)
      expect(trees).to eq([
        [3, 0, 3, 7, 3],
        [2, 5, 5, 1, 2],
        [6, 5, 3, 3, 2],
        [3, 3, 5, 4, 9],
        [3, 5, 3, 9, 0]
      ])
      # expect(visibility(trees)).to eq([
      #   [1, 1, 1, 1, 1],
      #   [1, 1, 1, 0, 1],
      #   [1, 1, 0, 1, 1],
      #   [1, 0, 1, 0, 1],
      #   [1, 1, 1, 1, 1],
      # ])
      expect(visibility(trees)).to eq(21)
    end
  end
else
  trees = parse_input(File.readlines(ARGV[0]))
  puts visibility(trees).flatten.sum
  puts most_scenic(trees)
end

__END__
30373
25512
65332
33549
35390
