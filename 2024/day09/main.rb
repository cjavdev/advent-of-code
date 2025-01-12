input = "2333133121414131402"
input = File.open("2024/day09/input").read

numbers = input.chars.map(&:to_i)
file_id_to_size = {}
file_system = []
file_id = 0

puts "Building file system..."
numbers.each_with_index do |number, index|
  if index.even?
    file_id_to_size[file_id] = number

    number.times do
      file_system << file_id
    end
    file_id += 1
  else
    number.times do
      file_system << :empty
    end
  end
end


puts "File system built. #{file_system.size} blocks."

# For each file id
(file_id - 1).downto(0) do |id|
  file_size = file_id_to_size[id]

  # Find the first series of n empty blocks that will fit the file
  available_index = file_system
    .each_cons(file_size)
    .with_index
    .find do |block, index|
      block.all? {|f| f == :empty}
    end


  if !available_index.nil?
    available_index = available_index[1]

    # If the available index is to the right of the current file, skip
    if available_index > file_system.index(id)
      next
    end

    file_system = file_system.map {|f| f == id ? :empty : f}
    file_system[available_index, file_size] = [id] * file_size
  end
end


# Part 1 Defragmentation
# puts "Defragmenting file system..."
# left = 0
# while file_system.include?(:empty)
#   x = file_system.pop

#   while file_system[left] != :empty
#     left += 1
#   end

#   if x != :empty
#     file_system[left] = x
#   end
#   p file_system.size
# end


sum = 0
file_system.each_with_index do |x, index|
  if x != :empty
    sum += x * index
  end
end
p sum