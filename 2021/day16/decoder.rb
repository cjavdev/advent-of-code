require 'byebug'

class Packet
  attr_reader :bits

  def initialize(bits)
    @bits = bits
    @cursor = 0
  end

  def literal?
    type_id == 4
  end

  def version
    bits[0...3].join.to_i(2)
  end

  def type_id
    bits[3...6].join.to_i(2)
  end
end

class OperatorPacket < Packet
  def sum_versions
    sub_packets.inject(version) {|a, p| a + p.sum_versions}
  end

  def sub_packets
    return @sub_packets if @sub_packets
    # Go through the content and parse out subpackets
    packets = []
    if length_type == 0
      start = 22
      stop = start + subpackets_length

      packet = Decoder.from_bits(bits[start...stop])
      packets << packet
      start += packet.end_index

      while start != stop
        packet = Decoder.from_bits(bits[start...stop])
        packets << packet
        start += packet.end_index
      end
    else
      start = 18
      stop = -1
      while packets.length < subpackets_length
        packet = Decoder.from_bits(bits[start...stop])
        packets << packet
        start += packet.end_index
      end
    end

    @sub_packets = packets
  end

  def length_type
    bits[6]
  end

  def content
    if length_type == 0
      bits[22...-1]
    else
      bits[18...-1]
    end
  end

  def subpackets_length
    if length_type == 0
      bits[7...7 + 15].join.to_i(2)
    else
      bits[7...7 + 11].join.to_i(2)
    end
  end
end

class LiteralPacket < Packet
  def sum_versions
    version
  end

  def end_index
    i = 6
    bits.drop(6).each_slice(5) do |x, *rest|
      i += 5
      return i if x.to_i == 0
    end
    -1
  end

  def value
    raise 'um no' if type_id != 4
    bits[6...end_index]
      .each_slice(5)
      .select {_1.length == 5}
      .flat_map {|_, *rest| rest}
      .join
      .to_i(2)
  end
end

class Decoder
  def self.parse(input)
    bits = input.chars.map do |ch|
      ch.to_i(16).to_s(2).rjust(4, '0')
    end.join.chars.map(&:to_i)
    from_bits(bits)
  end

  def self.from_bits(bits)
    packet = Packet.new(bits)
    if packet.literal?
      packet = LiteralPacket.new(bits)
    else
      packet = OperatorPacket.new(bits)
    end
    packet
  end
end

if __FILE__ == $0
  packet = Decoder.parse('C20D59802D2B0B6713C6B4D1600ACE7E3C179BFE391E546CC017F004A4F513C9D973A1B2F32C3004E6F9546D005840188C51DA298803F1863C42160068E5E37759BC4908C0109E76B00425E2C530DE40233CA9DE8022200EC618B10DC001098EF0A63910010D3843350C6D9A252805D2D7D7BAE1257FD95A6E928214B66DBE691E0E9005F7C00BC4BD22D733B0399979DA7E34A6850802809A1F9C4A947B91579C063005B001CF95B77504896A884F73D7EBB900641400E7CDFD56573E941E67EABC600B4C014C829802D400BCC9FA3A339B1C9A671005E35477200A0A551E8015591F93C8FC9E4D188018692429B0F930630070401B8A90663100021313E1C47900042A2B46C840600A580213681368726DEA008CEDAD8DD5A6181801460070801CE0068014602005A011ECA0069801C200718010C0302300AA2C02538007E2C01A100052AC00F210026AC0041492F4ADEFEF7337AAF2003AB360B23B3398F009005113B25FD004E5A32369C068C72B0C8AA804F0AE7E36519F6296D76509DE70D8C2801134F84015560034931C8044C7201F02A2A180258010D4D4E347D92AF6B35B93E6B9D7D0013B4C01D8611960E9803F0FA2145320043608C4284C4016CE802F2988D8725311B0D443700AA7A9A399EFD33CD5082484272BC9E67C984CF639A4D600BDE79EA462B5372871166AB33E001682557E5B74A0C49E25AACE76D074E7C5A6FD5CE697DC195C01993DCFC1D2A032BAA5C84C012B004C001098FD1FE2D00021B0821A45397350007F66F021291E8E4B89C118FE40180F802935CC12CD730492D5E2B180250F7401791B18CCFBBCD818007CB08A664C7373CEEF9FD05A73B98D7892402405802E000854788B91BC0010A861092124C2198023C0198880371222FC3E100662B45B8DB236C0F080172DD1C300820BCD1F4C24C8AAB0015F33D280')
  puts packet.sum_versions
end
