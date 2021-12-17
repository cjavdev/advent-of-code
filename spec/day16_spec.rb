require_relative '../day16/decoder.rb'

RSpec.describe LiteralPacket do
  let(:packet) do
    Decoder.parse('D2FE28')
  end

  it 'returns the end index and value' do
    expect(packet.version).to eq(6)
    expect(packet.type_id).to eq(4)
    expect(packet.value).to eq(2021)
    expect(packet.end_index).to eq(21)
  end
end

RSpec.describe OperatorPacket do
  let(:packet1) do
    Decoder.parse('38006F45291200')
  end
  let(:packet2) do
    Decoder.parse('EE00D40C823060')
  end
  let(:packet3) do
    Decoder.parse('8A004A801A8002F478')
  end
  let(:packet4) do
    Decoder.parse('620080001611562C8802118E34')
  end
  let(:packet5) { Decoder.parse('A0016C880162017C3686B18A3D4780') }

  it 'packet5' do
    expect(packet5.sum_versions).to eq(31)
  end

  it 'works for bigger packet' do
    #                   0000000000000000010110000100010101011000101100100010000000001000010001100011100011010
    # 01100010000000001000000000000000000101100001000101010110001011001000100000000010000100011000111000110100
    # VVVTTTILLLLLLLLLLL
    #                   VVVTTTILLLLLLLLLLLLLLL
    #                                         VVVTTTAAAAA
    #                                                    VVVTTTBBBBB
    #                                                               VVVTTTILLLLLLLLLLL
    #                                                                                 VVVTTTAAAAA
    #                                                                                            VVVTTTAAAAA
    #
    sub1, sub2 = packet4.sub_packets
    v1, v2 = sub1.sub_packets
    v3, v4 = sub2.sub_packets

    expect(packet4.version).to eq(3)
    expect(packet4).not_to be_literal
    expect(packet4.type_id).to eq(0)
    expect(packet4.length_type).to eq(1)
    expect(packet4.subpackets_length).to eq(2)
    expect(packet4.sub_packets.count).to eq(2)
    expect(packet4.content.join).to eq('0000000000000000010110000100010101011000101100100010000000001000010001100011100011010')

    expect(sub1.version).to eq(0)
    expect(sub1).not_to be_literal
    expect(sub1.type_id).to eq(0)
    expect(sub1.length_type).to eq(0)
    expect(sub1.subpackets_length).to eq(22)
    expect(sub1.sub_packets.count).to eq(2)

    expect(v1.version).to eq(0)
    expect(v1).to be_literal
    expect(v1.type_id).to eq(4)
    expect(v1.value).to eq(10)

    expect(v2.version).to eq(5)
    expect(v2).to be_literal
    expect(v2.type_id).to eq(4)
    expect(v2.value).to eq(11)

    p sub2.bits.join
    expect(sub2.version).to eq(1)
    expect(v1.version).to eq(0)
    expect(v2.version).to eq(5)
    expect(v3.version).to eq(0)
    expect(v4.version).to eq(3)
    expect(packet4.sum_versions).to eq(12)

    # expect(sub1.sub_packets.length).to eq(2)
    #
    # # 0001000101010110001011
    # # VVVTTT
    # expect(v1).to be_literal
    # expect(v1.version).to eq(0)
    # expect(v1.type_id).to eq(4)
    # expect(v1.value).to eq(10)
    #
    # # 10110001011
    # # VVVTTT
    # expect(v2).to be_literal
    # expect(v2.version).to eq(5)
    # expect(v2.value).to eq(11)
    #
    # #### sub2
    # p sub2.bits.join
    # expect(sub2.sub_packets.length).to eq(2)
    # expect(sub2.version).to eq(0)
    #
    # expect(v3).to be_literal
    # expect(v3.version).to eq(0)
    # expect(v4).to be_literal
    # expect(v4.version).to eq(5)
  end

  it 'works with embedded operator packets' do
    expect(packet3.version).to eq(4)
    expect(packet3.type_id).to eq(2)
    expect(packet3.subpackets_length).to eq(1)
    expect(packet3.sub_packets.length).to eq(1)
    expect(packet3.length_type).to eq(1)

    sub1 = packet3.sub_packets[0]
    expect(sub1.version).to eq(1)
    expect(sub1.type_id).to eq(2)
    expect(sub1.subpackets_length).to eq(1)
    expect(sub1.sub_packets.length).to eq(1)
    expect(sub1.length_type).to eq(1)

    sub2 = sub1.sub_packets[0]
    expect(sub2.version).to eq(5)
    expect(sub2.type_id).to eq(2)
    expect(sub2.length_type).to eq(0)
    expect(sub2.subpackets_length).to eq(11)
    expect(sub2.sub_packets.length).to eq(1)

    sub3 = sub2.sub_packets[0]
    expect(sub3.version).to eq(6)
    expect(sub3.type_id).to eq(4)
    expect(sub3.value).to eq(15)

    expect(packet3.sum_versions).to eq(16)
  end

  it 'has the right length type and subpackets length' do
    expect(packet1.version).to eq(1)
    expect(packet1.type_id).to eq(6)
    expect(packet1.length_type).to eq(0)
    expect(packet1.subpackets_length).to eq(27)
    expect(packet1.end_index).to eq(22 + 27)

    expect(packet1.sub_packets.map(&:value)).to eq([
      10, 20
    ])
  end

  it 'works with the type 1 length type' do
    p packet2.bits.join

    expect(packet2.version).to eq(7)
    expect(packet2.type_id).to eq(3)
    expect(packet2.length_type).to eq(1)
    expect(packet2.subpackets_length).to eq(3)

    expect(packet2.sub_packets.map(&:value)).to eq([1, 2, 3])
    expect(packet2.end_index).to eq(51)
  end
end

RSpec.describe Packet do
  it 'has the right version and type_id' do
    packet = Packet.new('110100101111111000101000'.chars)
    expect(packet.version).to eq(6)
    expect(packet.type_id).to eq(4)
  end
end

RSpec.describe Decoder do
  it 'decodes to the correct packet type' do
    packet = Decoder.parse('D2FE28')
    expect(packet).to be_a(LiteralPacket)

    packet = Decoder.parse('38006F45291200')
    expect(packet).to be_a(OperatorPacket)

    packet = Decoder.parse('8A004A801A8002F478')
    expect(packet).to be_a(OperatorPacket)
  end
end
