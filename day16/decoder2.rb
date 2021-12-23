require 'byebug'

class Bitstream
  attr_reader :sum_versions

  OPS = [
    :+,
    :*,
    -> (a, b) { [a, b].min },
    -> (a, b) { [a, b].max },
    nil,
    -> (a, b) { a > b ? 1 : 0 },
    -> (a, b) { a < b ? 1 : 0 },
    -> (a, b) { a == b ? 1 : 0 }
  ]

  def initialize(bits)
    @og_bits = bits.dup
    @bits = bits
    @read = 0
    @sum_versions = 0
  end

  def read_bits(n)
    @read += n
    ret = @bits.take(n)
    @bits = @bits.drop(n)
    ret
  end

  def get_literal
    number = []
    while true
      done = read_bits(1)[0]
      number_bits = read_bits(4)
      number += number_bits
      break if done == 0
    end
    number.join.to_i(2)
  end

  def decode
    version = read_bits(3).join.to_i(2)
    type_id = read_bits(3).join.to_i(2)
    @sum_versions += version

    if type_id == 4
      value = get_literal
    else
      length_type = read_bits(1)[0]
      literals = []
      if length_type == 0
        length = read_bits(15).join.to_i(2)
        pos = @read
        while pos + length > @read
          literals << decode
        end
      else
        num_packets = read_bits(11).join.to_i(2)
        num_packets.times do
          literals << decode
        end
      end
      p "Literals: #{literals} #{OPS[type_id]}"
      value = literals.inject(&OPS[type_id])
    end

    value
  end
end

class Decoder
  def self.parse(input)
    bits = input.chars.map do |ch|
      ch.to_i(16).to_s(2).rjust(4, '0')
    end.join.chars.map(&:to_i)
    Bitstream.new(bits)
  end
end

if __FILE__ == $0
  packet = Decoder.parse('8A004A801A8002F478')
  p packet.decode
  p [packet.sum_versions, 16]
  real_packet = Decoder.parse('C20D59802D2B0B6713C6B4D1600ACE7E3C179BFE391E546CC017F004A4F513C9D973A1B2F32C3004E6F9546D005840188C51DA298803F1863C42160068E5E37759BC4908C0109E76B00425E2C530DE40233CA9DE8022200EC618B10DC001098EF0A63910010D3843350C6D9A252805D2D7D7BAE1257FD95A6E928214B66DBE691E0E9005F7C00BC4BD22D733B0399979DA7E34A6850802809A1F9C4A947B91579C063005B001CF95B77504896A884F73D7EBB900641400E7CDFD56573E941E67EABC600B4C014C829802D400BCC9FA3A339B1C9A671005E35477200A0A551E8015591F93C8FC9E4D188018692429B0F930630070401B8A90663100021313E1C47900042A2B46C840600A580213681368726DEA008CEDAD8DD5A6181801460070801CE0068014602005A011ECA0069801C200718010C0302300AA2C02538007E2C01A100052AC00F210026AC0041492F4ADEFEF7337AAF2003AB360B23B3398F009005113B25FD004E5A32369C068C72B0C8AA804F0AE7E36519F6296D76509DE70D8C2801134F84015560034931C8044C7201F02A2A180258010D4D4E347D92AF6B35B93E6B9D7D0013B4C01D8611960E9803F0FA2145320043608C4284C4016CE802F2988D8725311B0D443700AA7A9A399EFD33CD5082484272BC9E67C984CF639A4D600BDE79EA462B5372871166AB33E001682557E5B74A0C49E25AACE76D074E7C5A6FD5CE697DC195C01993DCFC1D2A032BAA5C84C012B004C001098FD1FE2D00021B0821A45397350007F66F021291E8E4B89C118FE40180F802935CC12CD730492D5E2B180250F7401791B18CCFBBCD818007CB08A664C7373CEEF9FD05A73B98D7892402405802E000854788B91BC0010A861092124C2198023C0198880371222FC3E100662B45B8DB236C0F080172DD1C300820BCD1F4C24C8AAB0015F33D280')
  p real_packet.decode
  puts real_packet.sum_versions
end
