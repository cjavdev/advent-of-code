require '../day6/school.rb'

RSpec.describe School do
  it 'decreases the age when a day passes' do
    school = School.new([6])
    school.tick
    expect(school.ages).to eq([5])
  end

  it 'births a new fish if it reaches 0' do
    school = School.new([0])
    school.tick
    expect(school.ages).to eq([6, 8])
  end
end
