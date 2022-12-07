if ARGV.empty?
  data = DATA.readlines
else
  data = File.readlines(ARGV[0])
end

dir_sizes = Hash.new { |h, k| h[k] = 0 }
current_path = []

results = data
  .map(&:chomp)
  .map {_1.split(/ /)}
  .each do |line|
    case line
    in ["$", "cd", ".."]
      current_path.pop
    in ["$", "cd", dir]
      current_path << dir
    in ["$", "ls"]
    in ['dir', dirname]
    in [size, filename]
      current_path.length.times do |i|
        dir_sizes[current_path[0..i]] += size.to_i
      end
    end
  end

# Part 1
sum = 0
dir_sizes.each do |path, size|
  sum += size if size <= 100_000
end
puts "Part 1 #{sum}"

# Part 2
total = 70000000
needed = 30000000
used = dir_sizes[['/']]
unused = total - used
delete_atleast = needed - unused
puts "Delete at least #{delete_atleast}"

puts(dir_sizes.values.sort.find do |size|
  size >= delete_atleast
end)

# p dir_sizes
__END__
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
