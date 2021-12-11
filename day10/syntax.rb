require 'byebug'
class Subsystem
  PTS = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
  }
  def initialize(lines)
    @lines = lines
  end

  def score
    @lines.inject(0) do |score, line|
      if !line.illegal_char.nil? && PTS.has_key?(line.illegal_char)
        score += PTS[line.illegal_char]
      end
      score
    end
  end

  def incomplete_lines
    @lines.select { !_1.corrupted? }
  end

  def score2
    byebug
    sorted_scores = incomplete_lines.map { _1.score }.sort
    sorted_scores[sorted_scores.length / 2]
  end
end

class Line
  BRACKET_MAP = {
    '[' => ']',
    '(' => ')',
    '<' => '>',
    '{' => '}',
  }
  PTS2 = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
  }

  attr_reader :input
  def initialize(input)
    @input = input
  end

  def fix
    if !corrupted? && @fix.nil?
      @fix ||= @stack.map {BRACKET_MAP[_1]}
    end
    @fix.reverse
  end

  def score
    score = 0
    fix.each do |char|
      score *= 5
      score += PTS2[char]
    end
    score
  end

  def corrupted?
    !illegal_char.nil?
  end

  def illegal_char
    @stack = []
    @input.chars.each do |char|
      if BRACKET_MAP.keys.include?(char)
        @stack << char
      else
        if BRACKET_MAP[@stack.pop] != char
          return char
        end
      end
    end
    nil
  end
end

if __FILE__ == $0
  lines = File.readlines(ARGV.first).map {Line.new(_1.chomp)}
  sys = Subsystem.new(lines)
  puts sys.score2
end
