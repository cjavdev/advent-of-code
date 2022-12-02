require '../day1/number_of_increases.rb'

RSpec.describe "day1" do
  describe 'sum_of_windows' do
    it 'returns the sum of the numbers in the window with 4 elements' do
      expect(
        sum_of_windows(3, [1, 2, 3, 4])
      ).to eq([6, 9])
    end

    it 'returns the sum of the numbers in the window with 6' do
      expect(
        sum_of_windows(3, [1, 2, 3, 4, 5, 6])
      ).to eq([6, 9, 12, 15])
    end
  end

  describe 'number_of_increases' do
    it 'handles empty list of increases' do
      increases = number_of_increases([])
      expect(increases).to eq(0)
    end

    it 'handles a list with one item as expected' do
      increases = number_of_increases([1])
      expect(increases).to eq(0)
    end

    it 'handles a list with single increase' do
      increases = number_of_increases([2, 1, 2])
      expect(increases).to eq(1)
    end

    it 'handles a list with zero increases' do
      increases = number_of_increases([2, 1, 1])
      expect(increases).to eq(0)
    end

    it 'handles a list with two increases' do
      increases = number_of_increases([2, 1, 1, 2, 3])
      expect(increases).to eq(2)
    end

    it 'accurately finds 7 for the example' do
      increases = number_of_increases([
        199,
        200,
        208,
        210,
        200,
        207,
        240,
        269,
        260,
        263
      ])
      expect(increases).to eq(7)
    end
  end
end
