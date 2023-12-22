puts 'Hello, World!'
require 'byebug'

input = <<~INPUT
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
INPUT

input = <<~INPUT
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
INPUT

input = DATA.read

class Node
  def self.parse(line, nodes)
    n, dest = line.split(/ -> /)
    dest = dest.split(/, /).map(&:to_sym)
    kind = nil
    if n[0] == '%'
      name = n[1..-1].to_sym
      nodes[name] = FlipFlop.new(name, dest, nodes)
    elsif n[0] == '&'
      name = n[1..-1].to_sym
      nodes[name] = Conjunction.new(name, dest, nodes)
    elsif n == 'broadcaster'
      name = n.to_sym
      nodes[name] = Broadcaster.new(name, dest, nodes)
    else
      name = n.to_sym
      nodes[name] = Node.new(name, dest, nodes)
    end
  end

  attr_reader :name, :destinations, :nodes, :low_count, :high_count

  def initialize(name, destinations, nodes)
    @name = name
    @destinations = destinations
    @nodes = nodes
    @low_count = 0
    @high_count = 0
  end

  def low(from)
    @low_count += 1
    []
  end

  def high(from)
    @high_count += 1
    []
  end

  def get_low
    destinations.map do |dest|
      # puts "#{name} -low-> #{dest}"
      [dest, :low, name]
    end
  end

  def get_high
    destinations.map do |dest|
      # puts "#{name} -high-> #{dest}"
      [dest, :high, name]
    end
  end
end

class Rx < Node
  def low(from)
    raise "Rx sent low signal and is starting machine!"
  end
end

class FlipFlop < Node
  def initialize(name, destinations, nodes)
    @on = false
    super(name, destinations, nodes)
  end

  def on?
    @on
  end

  def low(from)
    super

    if on?
      @on = false
      get_low
    else
      @on = true
      get_high
    end
  end
end

class Conjunction < Node
  def initialize(name, destinations, nodes)
    @inputs = Hash.new {|h, k| h[k] = :low}
    super(name, destinations, nodes)
  end

  def input_nodes
    @input_nodes ||= nodes.select do |k, v|
      v.destinations.include?(name)
    end
  end

  def all_high?
    input_nodes.all? do |k, v|
      @inputs[k] == :high
    end
  end

  def high(from)
    @inputs[from] = :high
    super
    go
  end

  def low(from)
    @inputs[from] = :low
    super
    go
  end

  def go
    if all_high?
      # if name == :st
      #   puts "ST IS HIGH"
      # end

      get_low
    else
      get_high
    end
  end
end

class Broadcaster < Node
  def low(from)
    super
    get_low
  end
end

nodes = {}
input.split(/\n/).each do |line|
  Node.parse(line, nodes)
end
unknown = []
nodes.each do |k, v|
  v.destinations.each do |dest|
    if nodes[dest].nil?
      unknown << dest
    end
  end
end
unknown.each do |dest|
  if dest == :rx
    nodes[dest] = Rx.new(dest, [], nodes)
  else
    nodes[dest] = Node.new(dest, [], nodes)
  end
end
p unknown

def button(nodes)
  q = [[:broadcaster, :low, :from]]
  while !q.empty?
    name, status, from = q.shift
    q += nodes[name].send(status, from)
  end
end

# p nodes[:rx].low(nil)

# Part 1
# 1000.times do
#   button(nodes)
# end
# lc = nodes.sum { |k, v| v.low_count }
# hc = nodes.sum { |k, v| v.high_count }
# puts "Low counts: #{lc}, High counts: #{hc}, Total: #{hc * lc}"

# Part 2
begin
  button_presses = 0
  while button_presses < 10_000_000
    button_presses += 1
    button(nodes)
    # [
    #   :gr,
    #  # :tn, :hh, :dt
    # ].each do |name|
    if nodes[:gr].all_high?
      p "#{button_presses}: #{high_ones}"
      break
      # high_ones << name
    end
    # end
    # if high_ones.any?
    #   p "#{button_presses}: #{high_ones}"
    # end
    if button_presses % 1000 == 0
      puts "Button presses: #{button_presses}"
    end
  end
rescue => e
  puts "Button presses: #{button_presses}"
  p e
end

__END__
%np -> vn
&lv -> rx
&st -> lv
&gr -> tp, fs, px, st, th, sg
&tn -> lv
&vc -> gl, tv, pc, qd, tn, dg
&hh -> lv
&db -> np, gt, zj, ns, hh, rt
&dt -> lv
&lz -> dt, dk, qf
%rt -> ns
%th -> bc
%gt -> rt, db
%zf -> db, np
%sg -> fs, gr
%vn -> db, zj
%qh -> ms, lz
%rv -> rj, vc
%br -> lz, qh
%pc -> jq, vc
%dk -> xl
%qq -> th, gr
%ns -> xv
%bd -> lz, vm
%ms -> lz, bd
%dg -> rv
%cf -> vc
%kc -> cq, db
%ds -> dk, lz
%zj -> kc
%qm -> db, zf
%gl -> qd
%hf -> db
%hx -> px, gr
%fk -> tv, vc
%tp -> ld
%gg -> rq, gr
%xl -> gj, lz
%vm -> lz
%qf -> lz, vr
%px -> qq
%fs -> tp
%bc -> cd, gr
%vr -> xz, lz
%xv -> qm, db
%rq -> gr
%cq -> hf, db
%xz -> ds, lz
%qd -> dg
%jq -> vc, fk
%jp -> cf, vc
%rj -> jp, vc
%tv -> kz
%cd -> gg, gr
%ld -> hx, gr
%kz -> gl, vc
broadcaster -> pc, sg, qf, gt
%gj -> lz, br
