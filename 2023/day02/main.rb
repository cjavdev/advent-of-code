inp = <<~INP
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
INP

class Game
  attr_reader :id

  def self.parse(line)

    l, r = line.split(':')
    id = l.split(' ').last.to_i
    rounds = r
      .split(';')
      .map do |m|
        m.chomp
          .split(',')
          .map {_1.split(' ')}
          .map(&:reverse)
          .map { [_1.to_sym, _2.to_i]}
          .to_h
      end

    # p rounds
    new(id, rounds)
  end

  def initialize(id, rounds)
    @id = id
    @rounds = rounds
  end

  def min_cubes
    c = {
      red: 0,
      green: 0,
      blue: 0
    }

    @rounds.each do |r|
      r.each do |color, n|
        c[color] = n if n > c[color]
      end
    end
    c
  end

  def power
    min_cubes.values.inject(:*)
  end

  def possible?
    @rounds.all? do |r|

      r.all? do |c, n|
        {c =>n} in {red: ..12}|{green: ..13}|{blue: ..14}
      end

        # p color, n
        # if color == "red" && n > 12
        #   return false
        # elsif color == "blue" && n > 14
        #   return false
        # elsif color == "green" && n > 13
        #   return false
        # end
      #end
    end
   # true
  end
end


data = inp.each_line
#data = DATA.readlines
r = data.map do |line|
  g = Game.parse(line)
  p line
  # p g
  #p g.power
  p [g.id, g.possible?]
  # if g.possible?
  #   g.id
  # else
  #   0
  # end
end
# p r.sum

