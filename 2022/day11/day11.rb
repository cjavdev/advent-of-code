require 'byebug'
class Monkey
  @monkeys = {}
  attr_reader :inspection_count, :test

  def self.parse(input)
    n, i, op, t, tr, fl = input.split("\n")

    name = n.split(/ |:/)[1].to_i
    items = i.split(": ").last.split(", ").map(&:to_i)
    operation = op.split("= ").last
    test = t.split(/ /).last.to_i
    success = tr.split(/ /).last.to_i
    failure = fl.split(/ /).last.to_i

    @monkeys[name] = Monkey.new(
      name,
      items,
      operation,
      test,
      success,
      failure
    )
  end

  def self.all
    @monkeys
  end

  def self.active_monkeys
    @monkeys.values.sort_by { |m| -m.inspection_count }.take(2)
  end

  def self.monkey_business
    active_monkeys.map(&:inspection_count).inject(:*)
  end

  def self.relief
    @monkeys.values.map(&:test).inject(:*)
  end

  def initialize(name, items, operation, test, success, failure)
    @name = name
    @items = items
    @operation = operation
    @test = test
    @success = success
    @failure = failure
    @inspection_count = 0
  end

  def inspect_all
    while @items.any?
      insp
    end
  end

  def insp
    @inspection_count += 1
    item = @items.shift
    item = apply_operation(item)
    item /= 1
    item %= Monkey.relief
    to_monkey = apply_test(item)
    throw_item(to_monkey, item)
  end

  def apply_test(item)
    item % @test == 0 ? @success : @failure
  end

  def apply_operation(old)
    eval(@operation)
  end

  def throw_item(to_monkey, item)
    Monkey.all[to_monkey].catch_item(item)
  end

  def catch_item(item)
    @items << item
  end

  def inspect
    "<Monkey #{@name} has #{@items} items #{@inspection_count}>"
  end
end

# DATA.read.split("\n\n").each do |monkey_data|
#   Monkey.parse(monkey_data)
# end

File.read(ARGV[0]).split("\n\n").each do |monkey_data|
  Monkey.parse(monkey_data)
end

10000.times do
  Monkey.all.each do |name, monkey|
    monkey.inspect_all
  end
end
p Monkey.all
p Monkey.monkey_business


__END__
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
