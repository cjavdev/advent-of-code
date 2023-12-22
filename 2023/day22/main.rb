puts 'Hello, World!'
input = <<~INPUT
1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
INPUT

class Brick
  @@maxx = 0
  @@maxy = 0
  @@maxz = 0

  attr_reader :id, :x, :y, :z, :x2, :y2, :z2

  def initialize(id, *coords)
    @id = id
    @x, @y, @z, @x2, @y2, @z2 = coords
    @@maxx = [@@maxx, x, x2].max
    @@maxy = [@@maxy, y, y2].max
    @@maxz = [@@maxz, z, z2].max
  end

  def cubes
    return @cubes if @cubes
    @cubes = []
    (z..z2).each do |z_|
      (y..y2).each do |y_|
        (x..x2).each do |x_|
          @cubes << [x_,y_,z_]
        end
      end
    end
    @cubes
  end

  def drop!
    @z -= 1
    @z2 -= 1
    @cubes = nil
  end

  def undrop!
    @z += 1
    @z2 += 1
    @cubes = nil
  end

  def self.maxx
    @@maxx
  end

  def self.maxy
    @@maxy
  end

  def self.maxz
    @@maxz
  end

  def to_s
    "#{id}: #{x},#{y},#{z} ~ #{x2},#{y2},#{z2}"
  end
end

input = DATA.read

bricks = input.split("\n").map.with_index do |line, i|
  coords = line
    .split(/[,~]/)
    .map(&:to_i)
  Brick.new(i, *coords)
end

sky = Array.new(Brick.maxz + 1) do
  Array.new(Brick.maxy + 1) do
    Array.new(Brick.maxx + 1, nil)
  end
end

def valid_bricks?(bricks)
  brick_cubes = Set.new
  bricks.each do |brick|
    brick.cubes.each do |x,y,z|
      if z <= 0
        return false
      end
      if brick_cubes.include?([x,y,z])
        return false
      end
      brick_cubes << [x,y,z]
    end
  end
  true
end


def fall(bricks)
  # Move blocks down as far as they can go until they hit another cube
  shifts = 0
  dup_bricks = bricks.dup
  dup_bricks.each do |brick|
    brick.drop!
    if !valid_bricks?(bricks)
      brick.undrop!
    else
      shifts += 1
    end
  end
  if shifts > 0
    puts "falling #{shifts}"
    fall(dup_bricks)
  end
end

def can_fall?(bricks)
  # Move blocks down as far as they can go until they hit another cube
  dup_bricks = bricks.dup
  dup_bricks.each do |brick|
    brick.drop!
    if valid_bricks?(bricks)
      return true
    end
    brick.undrop!
  end
  false
end

puts "First fall:"
fall(bricks)

def disintigrate(bricks)
  count = 0
  bricks.combination(bricks.length - 1).each do |combo|
    if !can_fall?(combo)
      count += 1
    end
  end
  count
end

p disintigrate(bricks) - 1


# cubes = []
#
# bricks.each do |(x,y,z),(x2,y2,z2)|
#   (z..z2).each do |z_|
#     (y..y2).each do |y_|
#       (x..x2).each do |x_|
#         cubes << [x_,y_,z_]
#         sky[z_][y_][x_] = "#"
#       end
#     end
#   end
#   # break
# end
# p cubes

cubes = bricks.map(&:cubes).flatten(1).to_set
(0..Brick.maxz).each do |z|
  puts "layer #{z}"
  (0..Brick.maxy).each do |y|
    (0..Brick.maxx).each do |x|
      if cubes.include?([x,y,z])
        print "#"
      else
        print "."
      end
    end
    puts
  end
  puts "----------"
end

#
# # puts "layer #{z}"
# (0..maxy).each do |y|
#   (0..maxz).each do |z|
#     (0..maxx).each do |x|
#       print sky[z][y][x]
#     end
#     puts
#   end
#   puts "----------"
# end

# 1245 is too high

__END__
4,5,12~5,5,12
7,2,253~9,2,253
2,3,7~2,4,7
2,5,169~4,5,169
5,7,102~5,9,102
7,3,3~9,3,3
1,0,156~1,2,156
4,5,258~4,5,260
9,7,194~9,8,194
9,3,198~9,5,198
6,5,145~6,5,148
4,9,193~7,9,193
0,3,229~3,3,229
7,3,183~7,3,183
2,5,99~2,6,99
1,9,16~4,9,16
1,0,253~1,0,255
8,6,69~8,7,69
1,9,116~3,9,116
5,2,186~6,2,186
2,1,110~2,5,110
5,7,211~5,7,213
4,1,74~4,1,76
0,4,99~0,6,99
8,4,109~9,4,109
3,6,220~3,6,222
6,5,143~8,5,143
3,8,217~3,8,218
7,0,200~7,3,200
2,3,83~3,3,83
5,6,156~5,9,156
7,2,203~7,5,203
8,3,58~8,6,58
6,0,56~6,0,58
6,4,20~9,4,20
9,3,162~9,4,162
6,4,43~6,7,43
4,0,112~4,3,112
5,2,142~5,4,142
8,3,168~8,3,169
6,1,40~6,3,40
5,6,59~5,8,59
7,2,113~9,2,113
1,6,229~4,6,229
2,3,168~2,6,168
8,5,161~8,8,161
5,0,149~5,0,151
1,7,98~2,7,98
7,0,222~7,0,224
7,2,17~7,5,17
0,1,179~3,1,179
2,5,3~2,7,3
7,2,251~7,5,251
4,0,161~4,0,162
6,3,172~8,3,172
8,0,148~8,4,148
6,1,160~7,1,160
6,5,131~6,5,133
3,7,221~5,7,221
4,4,108~6,4,108
7,4,98~7,6,98
2,4,95~2,6,95
0,2,174~0,5,174
7,5,32~9,5,32
5,5,195~6,5,195
6,6,45~6,7,45
3,0,194~5,0,194
6,9,12~8,9,12
3,2,203~4,2,203
3,2,168~3,2,168
6,8,166~9,8,166
6,7,231~6,9,231
1,1,215~3,1,215
7,8,142~7,8,142
1,5,168~1,5,169
4,3,55~4,5,55
3,6,152~3,7,152
5,1,128~9,1,128
2,0,131~4,0,131
2,1,125~5,1,125
6,7,244~8,7,244
9,2,232~9,5,232
4,4,80~4,4,82
2,4,155~2,7,155
3,7,69~5,7,69
1,6,82~1,8,82
4,4,266~7,4,266
2,4,157~2,4,158
9,3,99~9,3,101
2,5,73~3,5,73
0,1,126~0,4,126
4,1,139~6,1,139
1,4,202~1,5,202
0,2,49~2,2,49
1,7,86~1,8,86
2,1,189~2,4,189
2,6,115~2,7,115
7,3,74~7,5,74
6,2,46~7,2,46
4,2,103~4,2,104
6,6,117~8,6,117
1,5,263~3,5,263
1,8,128~1,8,131
1,6,127~1,9,127
7,5,87~9,5,87
2,3,203~3,3,203
1,4,22~1,6,22
5,9,16~6,9,16
7,4,265~7,7,265
2,3,226~2,4,226
5,1,259~5,3,259
8,8,27~8,9,27
0,3,82~3,3,82
8,7,71~8,9,71
5,2,107~8,2,107
4,3,137~6,3,137
2,7,207~2,9,207
1,1,111~4,1,111
8,3,104~9,3,104
9,5,203~9,6,203
5,1,45~7,1,45
1,6,179~1,8,179
4,3,268~4,4,268
6,0,49~6,3,49
8,8,106~9,8,106
6,3,29~6,5,29
9,6,139~9,8,139
9,2,239~9,5,239
7,0,157~7,3,157
1,4,58~4,4,58
6,3,200~6,4,200
8,4,34~8,7,34
5,3,90~5,6,90
0,6,185~0,9,185
4,4,159~6,4,159
9,6,185~9,8,185
8,3,16~8,3,18
6,5,142~8,5,142
5,0,264~5,1,264
0,2,201~0,4,201
6,5,230~8,5,230
3,7,85~4,7,85
5,5,32~5,8,32
0,0,167~1,0,167
2,5,244~2,7,244
6,3,191~7,3,191
4,5,160~4,7,160
2,8,62~3,8,62
4,2,96~4,4,96
0,4,61~2,4,61
9,1,97~9,5,97
3,5,120~3,8,120
6,1,254~6,4,254
8,8,169~8,8,170
4,0,249~6,0,249
5,8,19~8,8,19
6,8,173~8,8,173
0,0,217~1,0,217
7,3,71~9,3,71
5,7,173~6,7,173
4,1,211~7,1,211
9,4,242~9,5,242
3,0,3~3,1,3
6,4,248~8,4,248
0,6,73~3,6,73
1,5,223~3,5,223
3,5,197~4,5,197
5,8,159~5,9,159
3,0,90~3,2,90
6,4,111~6,6,111
4,0,115~4,1,115
2,3,178~2,5,178
1,6,129~1,6,131
9,3,196~9,3,196
1,1,130~1,4,130
7,2,227~7,5,227
6,9,216~9,9,216
0,7,164~2,7,164
2,8,174~4,8,174
7,9,100~8,9,100
3,4,261~3,5,261
3,3,266~3,5,266
7,2,49~7,2,51
3,3,124~3,5,124
8,3,246~9,3,246
9,5,260~9,7,260
3,5,246~3,6,246
9,7,98~9,9,98
2,1,207~4,1,207
4,0,73~4,3,73
4,9,217~7,9,217
0,5,231~0,7,231
4,4,105~4,6,105
5,5,8~7,5,8
6,4,1~8,4,1
3,6,207~3,6,209
8,6,130~8,9,130
8,6,97~8,9,97
3,0,145~5,0,145
2,5,214~2,8,214
1,7,1~3,7,1
9,0,168~9,3,168
8,0,29~9,0,29
7,1,109~7,1,109
4,8,124~4,8,126
4,9,231~4,9,233
6,8,241~9,8,241
3,0,219~4,0,219
2,1,201~2,3,201
0,0,29~0,2,29
5,1,209~5,4,209
4,3,2~5,3,2
0,8,12~3,8,12
5,4,94~5,6,94
2,1,122~2,2,122
1,1,72~2,1,72
7,3,241~9,3,241
7,1,247~8,1,247
1,0,143~5,0,143
1,4,65~3,4,65
1,8,175~3,8,175
5,5,205~5,5,207
0,4,130~0,6,130
6,9,196~7,9,196
3,9,182~3,9,184
5,5,128~5,8,128
4,1,244~8,1,244
4,0,196~5,0,196
9,0,188~9,2,188
7,4,229~9,4,229
2,2,38~2,3,38
6,0,206~7,0,206
2,8,95~5,8,95
7,4,263~9,4,263
2,0,19~2,2,19
4,4,152~4,6,152
8,4,23~8,8,23
3,3,79~5,3,79
6,2,255~6,2,256
1,8,163~3,8,163
3,2,92~4,2,92
4,7,26~4,8,26
4,2,189~5,2,189
9,7,3~9,7,6
1,4,269~1,5,269
2,4,147~2,4,147
0,1,37~3,1,37
1,4,93~3,4,93
1,7,215~2,7,215
0,3,25~2,3,25
1,7,17~1,9,17
1,2,107~1,2,109
7,2,249~7,4,249
2,9,24~5,9,24
4,8,229~5,8,229
6,6,229~6,6,231
9,4,58~9,6,58
6,5,128~9,5,128
0,2,198~0,3,198
5,3,86~5,5,86
4,0,217~7,0,217
7,5,55~9,5,55
1,2,97~1,4,97
2,5,166~2,5,167
8,7,35~9,7,35
8,4,10~8,7,10
2,5,254~4,5,254
6,1,248~8,1,248
8,0,241~9,0,241
6,2,213~6,3,213
7,3,238~7,4,238
7,9,181~9,9,181
8,6,141~8,7,141
7,1,212~9,1,212
8,8,101~8,8,103
0,1,53~0,2,53
5,5,15~5,5,17
0,0,156~0,2,156
1,8,30~4,8,30
1,4,177~1,6,177
0,5,127~1,5,127
7,4,259~9,4,259
0,5,228~0,7,228
8,7,171~8,7,173
2,7,60~2,7,60
6,3,256~8,3,256
2,0,186~2,2,186
0,5,71~1,5,71
2,3,197~2,3,199
5,8,147~7,8,147
0,5,38~1,5,38
0,5,188~2,5,188
1,7,234~1,9,234
2,1,203~4,1,203
4,7,122~4,9,122
8,7,200~8,9,200
6,0,43~6,3,43
7,0,150~9,0,150
2,7,223~4,7,223
2,8,127~4,8,127
1,5,167~1,7,167
0,3,27~0,5,27
6,8,245~7,8,245
4,0,14~6,0,14
1,2,86~1,5,86
0,3,252~0,5,252
3,9,100~4,9,100
7,8,51~9,8,51
5,7,87~7,7,87
2,6,276~2,8,276
5,9,191~7,9,191
5,7,18~7,7,18
1,2,266~1,5,266
1,0,128~2,0,128
4,8,155~7,8,155
2,2,116~2,4,116
1,0,125~1,2,125
9,6,257~9,8,257
3,2,125~5,2,125
3,6,36~5,6,36
9,7,243~9,9,243
3,7,238~3,8,238
6,3,36~6,6,36
2,6,226~4,6,226
2,3,140~5,3,140
3,4,84~5,4,84
1,4,12~3,4,12
7,7,138~9,7,138
0,7,189~0,8,189
9,2,158~9,4,158
2,3,40~2,3,42
5,0,53~7,0,53
1,3,181~1,5,181
7,3,131~7,3,132
0,1,184~2,1,184
0,4,16~0,4,17
4,8,178~4,8,179
1,3,121~4,3,121
6,5,191~9,5,191
5,2,88~5,5,88
3,2,127~5,2,127
8,6,48~8,7,48
4,0,156~7,0,156
5,7,61~5,8,61
6,9,139~9,9,139
3,5,17~3,7,17
6,6,222~6,9,222
2,4,60~3,4,60
8,8,163~9,8,163
3,5,11~5,5,11
3,6,259~3,6,261
6,1,80~6,3,80
4,0,202~4,3,202
3,9,244~3,9,246
7,5,67~7,5,69
5,8,233~7,8,233
0,7,79~1,7,79
0,3,23~2,3,23
3,2,109~5,2,109
0,3,83~0,5,83
1,5,63~1,6,63
8,7,163~9,7,163
1,1,263~1,4,263
4,1,150~4,2,150
0,1,128~0,1,130
3,9,178~3,9,180
2,0,71~2,2,71
4,9,99~7,9,99
2,9,228~5,9,228
3,6,106~4,6,106
1,4,81~1,6,81
7,5,140~7,8,140
6,6,147~8,6,147
0,0,51~1,0,51
6,5,80~7,5,80
5,9,108~8,9,108
5,2,56~7,2,56
8,4,82~8,4,83
7,0,132~7,1,132
0,5,183~0,7,183
2,6,182~2,8,182
5,0,154~5,1,154
9,4,22~9,6,22
7,3,235~9,3,235
9,4,151~9,6,151
9,1,137~9,3,137
0,1,210~2,1,210
5,0,42~5,2,42
6,3,15~8,3,15
3,6,13~3,9,13
9,6,215~9,7,215
6,4,228~6,7,228
1,3,272~1,6,272
6,4,57~6,5,57
1,0,215~2,0,215
8,3,190~8,5,190
1,7,225~3,7,225
3,3,16~6,3,16
6,8,243~6,8,244
1,6,78~1,7,78
6,1,193~6,3,193
6,0,218~9,0,218
6,4,87~8,4,87
7,0,5~7,0,6
1,6,233~1,6,233
1,1,190~1,5,190
6,0,137~6,2,137
7,2,54~9,2,54
7,2,185~7,3,185
6,3,31~8,3,31
6,4,14~8,4,14
1,6,55~4,6,55
4,2,75~4,3,75
6,6,113~6,8,113
6,4,137~6,5,137
2,5,256~2,7,256
9,6,258~9,7,258
7,4,239~7,6,239
7,7,13~7,9,13
8,8,179~8,9,179
8,5,67~9,5,67
3,3,213~3,6,213
0,3,179~2,3,179
6,5,84~6,7,84
1,6,21~3,6,21
5,4,174~5,6,174
4,1,85~4,4,85
6,0,3~6,1,3
1,1,2~1,1,4
2,1,151~4,1,151
9,0,160~9,4,160
0,2,180~1,2,180
0,2,193~0,4,193
4,6,107~4,8,107
2,0,35~2,2,35
0,2,51~1,2,51
6,6,101~9,6,101
4,4,162~6,4,162
6,5,120~6,7,120
7,6,102~7,8,102
0,2,238~2,2,238
3,0,247~3,2,247
7,7,176~8,7,176
5,8,193~5,8,194
3,6,230~3,6,232
2,5,217~2,7,217
5,6,33~7,6,33
4,9,14~6,9,14
6,8,235~6,8,238
5,1,86~5,2,86
4,5,173~4,6,173
6,0,214~9,0,214
2,3,180~2,3,180
7,0,143~7,2,143
6,4,47~6,7,47
4,3,17~4,5,17
8,0,82~8,3,82
5,1,146~8,1,146
1,6,101~3,6,101
5,6,144~8,6,144
6,4,114~6,6,114
7,0,175~7,1,175
6,6,123~6,8,123
2,6,238~5,6,238
8,6,135~8,8,135
7,5,35~7,5,38
2,3,152~3,3,152
7,0,3~9,0,3
9,2,247~9,5,247
4,6,57~6,6,57
1,1,114~1,1,115
6,7,182~9,7,182
9,4,98~9,5,98
4,5,213~6,5,213
8,1,11~9,1,11
5,1,57~5,2,57
1,1,221~4,1,221
5,8,274~5,9,274
7,7,185~7,9,185
2,2,123~5,2,123
7,0,134~7,0,135
6,3,112~7,3,112
8,7,215~8,9,215
6,0,244~9,0,244
7,6,52~7,9,52
1,0,22~2,0,22
5,6,164~9,6,164
8,3,200~8,4,200
4,7,226~4,9,226
2,2,251~2,3,251
1,7,188~1,9,188
4,5,3~5,5,3
3,4,204~3,6,204
0,1,231~0,3,231
0,0,201~2,0,201
2,3,107~2,5,107
3,8,198~5,8,198
8,1,213~9,1,213
4,0,12~4,0,12
3,2,108~5,2,108
3,9,141~6,9,141
3,9,49~5,9,49
3,0,147~5,0,147
7,4,260~8,4,260
8,8,197~9,8,197
3,5,235~3,8,235
8,4,203~8,6,203
3,6,131~6,6,131
1,5,102~2,5,102
7,4,7~7,7,7
8,5,146~8,7,146
3,2,102~5,2,102
9,5,174~9,7,174
5,6,46~8,6,46
3,1,195~4,1,195
6,8,187~6,8,189
4,6,60~4,9,60
1,4,108~1,5,108
1,0,31~3,0,31
4,1,250~4,1,251
7,7,23~7,9,23
2,2,152~2,2,154
6,0,88~7,0,88
1,1,192~3,1,192
6,9,143~6,9,145
0,5,180~0,8,180
1,5,110~1,7,110
3,9,224~5,9,224
2,9,62~4,9,62
7,2,267~7,5,267
0,3,196~0,5,196
7,3,100~7,5,100
8,9,30~8,9,32
4,5,67~4,8,67
3,0,11~6,0,11
9,2,163~9,2,165
1,3,157~1,3,159
7,5,165~7,7,165
6,7,101~8,7,101
7,7,212~9,7,212
5,6,47~5,9,47
7,5,105~7,7,105
1,1,223~3,1,223
3,2,35~4,2,35
2,1,120~2,4,120
2,6,251~5,6,251
9,7,109~9,9,109
1,4,192~1,5,192
7,3,82~7,3,82
2,4,227~2,4,231
6,1,73~6,2,73
2,3,177~2,4,177
5,0,198~8,0,198
1,6,3~1,6,6
1,3,163~4,3,163
5,3,165~9,3,165
3,7,33~5,7,33
3,1,25~3,4,25
3,3,216~3,3,216
3,6,111~3,7,111
2,7,230~4,7,230
9,3,236~9,3,236
4,0,247~4,3,247
7,1,174~7,4,174
7,8,53~7,8,54
7,6,214~7,8,214
9,3,84~9,6,84
8,1,164~8,3,164
5,7,4~7,7,4
3,3,123~3,3,123
9,0,170~9,2,170
6,9,74~8,9,74
9,1,56~9,4,56
6,3,37~9,3,37
5,0,105~5,2,105
4,6,10~7,6,10
7,4,185~8,4,185
5,2,161~5,4,161
3,9,277~5,9,277
1,4,88~4,4,88
7,8,133~9,8,133
4,3,99~4,5,99
3,2,260~3,3,260
5,8,40~6,8,40
4,8,92~8,8,92
1,4,62~1,5,62
2,9,143~5,9,143
2,9,210~3,9,210
1,6,74~1,8,74
8,3,243~9,3,243
5,3,187~5,7,187
9,6,161~9,8,161
9,2,184~9,5,184
6,3,38~9,3,38
3,4,251~3,5,251
0,3,2~0,3,3
5,7,233~7,7,233
6,3,11~6,5,11
7,2,187~7,4,187
7,0,265~7,2,265
2,8,273~5,8,273
1,5,227~2,5,227
5,5,45~7,5,45
2,5,53~5,5,53
2,1,254~5,1,254
8,1,31~8,1,31
5,1,8~9,1,8
7,3,86~8,3,86
4,1,106~4,3,106
1,4,162~1,7,162
9,3,156~9,6,156
4,0,203~6,0,203
3,4,196~3,7,196
5,9,10~7,9,10
5,4,126~5,5,126
5,8,69~8,8,69
1,6,25~1,9,25
8,4,35~8,6,35
0,4,11~0,4,13
5,6,188~5,6,189
7,5,64~7,7,64
5,4,217~7,4,217
4,6,176~4,6,178
7,4,126~7,6,126
6,4,155~6,7,155
3,6,9~3,8,9
0,1,221~0,4,221
1,7,220~1,8,220
4,6,276~4,9,276
8,1,174~8,3,174
2,2,144~2,4,144
8,1,28~8,2,28
0,3,249~1,3,249
3,4,3~3,6,3
7,1,130~7,3,130
1,2,105~1,5,105
7,0,221~9,0,221
1,2,160~1,5,160
1,9,211~3,9,211
0,1,234~0,4,234
5,7,190~5,9,190
4,1,108~7,1,108
4,3,69~7,3,69
1,9,240~1,9,240
5,0,129~5,2,129
4,6,161~4,7,161
2,4,203~4,4,203
5,7,209~8,7,209
4,4,49~4,7,49
4,4,61~5,4,61
4,4,230~4,5,230
5,5,176~5,5,179
0,9,92~1,9,92
5,1,262~8,1,262
7,6,97~7,9,97
1,4,125~1,6,125
3,5,194~5,5,194
1,7,125~1,7,126
3,9,105~5,9,105
3,8,17~5,8,17
8,4,84~8,6,84
4,3,12~6,3,12
5,5,123~8,5,123
6,4,206~7,4,206
1,0,49~1,1,49
1,0,150~1,3,150
1,4,174~4,4,174
2,0,25~2,2,25
6,6,170~7,6,170
6,0,181~7,0,181
6,5,3~6,7,3
5,1,76~8,1,76
4,3,206~7,3,206
0,5,131~0,7,131
2,5,171~4,5,171
4,3,46~4,4,46
7,4,49~7,6,49
7,2,61~7,4,61
6,6,165~6,6,167
4,6,244~5,6,244
5,6,85~5,8,85
3,8,197~5,8,197
6,7,6~8,7,6
2,0,206~4,0,206
0,4,119~3,4,119
3,3,63~3,5,63
2,3,141~2,5,141
8,1,114~8,3,114
5,0,218~5,3,218
0,9,2~3,9,2
0,4,78~0,6,78
4,2,149~4,4,149
1,1,181~5,1,181
7,4,191~7,4,191
0,4,171~3,4,171
0,6,121~2,6,121
0,0,91~3,0,91
3,5,66~5,5,66
2,7,20~3,7,20
5,9,103~8,9,103
7,4,4~7,4,5
8,2,249~8,4,249
0,0,27~3,0,27
0,1,123~0,4,123
5,5,149~9,5,149
7,6,173~7,6,175
1,3,45~2,3,45
4,7,131~5,7,131
3,5,82~3,8,82
5,1,223~5,3,223
3,4,98~3,6,98
8,3,259~8,3,261
9,3,91~9,5,91
9,6,165~9,7,165
9,1,10~9,3,10
2,6,79~5,6,79
8,4,215~9,4,215
5,0,183~5,1,183
6,5,9~8,5,9
1,0,209~1,1,209
4,9,188~6,9,188
3,5,225~5,5,225
0,4,85~0,5,85
2,6,52~2,9,52
6,4,225~6,7,225
5,6,271~5,8,271
1,0,205~4,0,205
2,1,68~4,1,68
3,6,134~3,6,137
3,1,210~3,2,210
2,6,211~4,6,211
2,8,1~3,8,1
5,3,220~5,3,221
2,3,22~4,3,22
4,7,121~6,7,121
7,8,95~9,8,95
8,3,107~8,5,107
9,6,8~9,9,8
6,5,250~6,7,250
0,5,186~0,7,186
0,9,98~2,9,98
3,0,158~5,0,158
1,0,213~1,3,213
5,3,225~8,3,225
3,5,148~3,6,148
2,8,97~4,8,97
3,2,225~5,2,225
9,4,152~9,4,155
0,0,219~2,0,219
6,1,203~8,1,203
1,0,250~3,0,250
2,2,13~2,2,16
7,7,179~9,7,179
1,8,61~3,8,61
5,7,39~5,9,39
3,1,224~3,1,226
0,4,9~2,4,9
4,7,270~7,7,270
2,0,161~3,0,161
1,3,153~1,3,155
8,0,204~8,2,204
0,0,92~2,0,92
0,8,118~0,9,118
4,8,12~7,8,12
4,3,50~4,5,50
7,3,213~7,4,213
4,3,47~6,3,47
6,3,197~8,3,197
4,8,173~5,8,173
9,5,90~9,7,90
7,1,110~7,3,110
5,0,140~7,0,140
0,9,236~2,9,236
2,2,11~2,4,11
0,9,87~2,9,87
3,3,95~3,6,95
1,5,104~2,5,104
6,7,20~8,7,20
3,1,213~4,1,213
6,5,216~8,5,216
6,2,212~6,4,212
8,6,178~8,6,180
8,0,206~8,1,206
4,0,51~6,0,51
3,1,263~4,1,263
0,8,241~2,8,241
1,1,206~3,1,206
6,0,86~6,2,86
1,3,197~1,5,197
3,6,117~3,8,117
2,3,24~2,5,24
4,5,130~5,5,130
4,2,79~8,2,79
6,2,214~8,2,214
3,7,4~3,7,6
0,5,22~0,8,22
3,0,4~3,0,6
7,4,256~9,4,256
7,3,180~7,5,180
0,6,23~0,8,23
3,6,150~3,8,150
4,1,95~4,3,95
1,5,278~1,8,278
5,7,7~5,9,7
0,1,218~1,1,218
2,6,58~2,8,58
6,2,8~9,2,8
2,7,96~4,7,96
3,7,275~3,9,275
2,3,94~3,3,94
2,3,195~2,5,195
6,3,178~6,4,178
2,6,23~4,6,23
8,2,228~8,5,228
6,2,169~6,2,170
1,8,110~4,8,110
4,2,249~6,2,249
0,4,10~0,6,10
6,0,209~6,3,209
7,5,221~7,5,224
5,2,194~7,2,194
5,0,161~7,0,161
4,6,2~4,9,2
3,9,163~5,9,163
7,3,194~9,3,194
0,3,67~1,3,67
2,9,50~3,9,50
2,6,243~4,6,243
9,2,25~9,4,25
0,9,18~2,9,18
3,1,149~3,3,149
5,3,250~5,6,250
3,0,117~4,0,117
0,3,22~0,4,22
5,4,267~5,6,267
0,0,258~0,1,258
2,1,92~2,3,92
9,4,135~9,5,135
0,1,54~1,1,54
3,7,160~3,9,160
6,3,250~7,3,250
5,7,143~7,7,143
3,4,72~3,6,72
5,3,168~5,3,169
0,4,74~3,4,74
1,2,2~2,2,2
6,2,26~9,2,26
2,7,176~5,7,176
4,9,123~7,9,123
3,9,78~5,9,78
7,1,14~7,2,14
3,1,174~3,3,174
0,9,100~0,9,101
5,0,191~5,3,191
7,5,47~9,5,47
8,6,158~9,6,158
7,5,181~9,5,181
0,3,65~3,3,65
1,0,9~4,0,9
7,3,81~9,3,81
1,2,84~1,4,84
7,5,171~9,5,171
3,2,3~3,3,3
1,7,114~1,9,114
1,4,231~1,7,231
2,1,218~4,1,218
6,4,251~6,4,251
5,6,83~6,6,83
0,1,177~0,5,177
3,5,65~5,5,65
8,9,203~9,9,203
5,7,50~5,7,50
6,1,109~6,3,109
7,2,268~7,3,268
4,6,232~4,7,232
4,1,157~6,1,157
3,7,241~3,9,241
2,6,225~3,6,225
5,9,27~5,9,29
3,3,257~3,6,257
5,5,171~5,8,171
0,4,120~0,7,120
2,4,242~3,4,242
5,3,177~7,3,177
1,4,163~3,4,163
1,9,227~3,9,227
9,5,66~9,7,66
6,2,167~6,3,167
9,0,187~9,2,187
8,2,199~8,4,199
0,6,122~2,6,122
2,8,278~2,9,278
0,5,275~2,5,275
5,1,210~7,1,210
8,6,222~8,8,222
9,7,192~9,9,192
5,5,273~5,6,273
5,8,144~8,8,144
1,5,37~1,8,37
4,4,44~6,4,44
1,2,96~3,2,96
6,0,180~6,2,180
9,3,16~9,5,16
6,7,80~8,7,80
5,8,78~8,8,78
6,7,255~9,7,255
4,3,141~6,3,141
6,0,255~6,1,255
5,6,165~5,7,165
0,8,26~0,9,26
0,3,68~0,6,68
6,9,26~8,9,26
1,3,232~4,3,232
4,0,221~6,0,221
4,5,172~5,5,172
0,0,157~0,2,157
1,6,218~1,7,218
3,4,200~3,5,200
6,7,49~6,8,49
7,7,225~7,9,225
4,5,228~4,7,228
0,0,28~2,0,28
5,6,222~5,9,222
3,7,157~4,7,157
4,2,66~4,4,66
8,6,98~8,8,98
5,4,133~5,4,136
2,3,169~2,3,170
1,9,56~3,9,56
4,0,204~6,0,204
1,0,119~3,0,119
3,4,108~3,6,108
3,2,105~3,4,105
2,8,111~4,8,111
6,3,210~6,5,210
5,1,50~8,1,50
1,0,34~2,0,34
3,1,34~3,4,34
4,7,24~6,7,24
2,4,214~4,4,214
9,7,270~9,9,270
1,8,216~3,8,216
3,2,185~6,2,185
1,7,122~3,7,122
1,5,165~2,5,165
5,1,41~7,1,41
0,7,5~0,9,5
5,1,255~5,2,255
1,7,183~2,7,183
9,4,202~9,6,202
0,1,176~0,3,176
6,4,220~6,6,220
7,5,14~9,5,14
5,5,25~7,5,25
9,2,132~9,5,132
4,5,255~4,6,255
9,0,6~9,3,6
7,1,241~8,1,241
2,3,155~5,3,155
2,2,155~3,2,155
4,5,106~4,5,107
7,1,163~8,1,163
2,5,13~2,8,13
4,8,14~6,8,14
4,3,102~6,3,102
1,8,246~2,8,246
6,4,59~6,7,59
5,3,132~5,5,132
5,1,213~5,3,213
4,6,136~4,7,136
3,1,261~3,3,261
6,5,156~6,8,156
1,5,194~1,6,194
8,0,238~8,3,238
5,7,129~8,7,129
1,8,85~1,9,85
5,7,70~5,8,70
8,6,176~9,6,176
5,5,256~7,5,256
5,0,141~5,2,141
1,7,113~2,7,113
1,3,127~1,4,127
4,6,62~4,7,62
1,9,145~2,9,145
2,1,150~2,3,150
2,0,198~4,0,198
2,3,154~5,3,154
6,5,82~6,6,82
5,1,46~5,2,46
5,4,40~7,4,40
7,5,20~7,5,22
5,2,93~5,4,93
9,3,92~9,5,92
4,1,19~4,3,19
5,8,146~8,8,146
2,5,153~4,5,153
7,3,77~7,5,77
2,6,5~2,6,6
5,8,223~7,8,223
6,0,44~8,0,44
4,1,65~4,2,65
2,5,174~3,5,174
8,7,65~9,7,65
7,0,94~7,2,94
5,1,226~5,1,229
8,2,80~8,4,80
9,8,187~9,8,191
7,4,183~9,4,183
4,5,163~5,5,163
9,9,204~9,9,206
5,0,205~7,0,205
6,6,136~6,9,136
3,8,158~4,8,158
0,5,225~2,5,225
1,6,20~3,6,20
1,3,147~4,3,147
5,5,153~5,8,153
8,4,253~8,7,253
4,6,93~4,9,93
6,2,72~6,4,72
0,1,237~0,4,237
2,2,5~2,4,5
7,0,246~7,0,249
1,5,18~4,5,18
1,2,89~4,2,89
4,4,156~6,4,156
4,1,149~6,1,149
8,0,143~8,2,143
5,0,211~7,0,211
2,1,126~2,3,126
0,9,188~0,9,191
5,1,256~7,1,256
3,7,15~5,7,15
8,5,169~8,7,169
6,6,272~6,7,272
7,5,90~7,7,90
5,5,253~5,9,253
4,5,231~6,5,231
7,5,167~9,5,167
9,6,193~9,7,193
3,1,28~3,1,31
6,5,28~9,5,28
7,6,71~7,8,71
1,7,238~1,9,238
3,3,237~3,5,237
8,4,264~8,6,264
6,5,77~6,8,77
7,7,256~9,7,256
3,1,229~3,1,231
9,3,202~9,3,204
6,7,186~6,9,186
2,0,221~2,0,221
6,2,58~6,5,58
8,1,14~8,1,16
7,5,257~7,6,257
3,2,165~3,3,165
5,3,260~6,3,260
1,5,77~1,7,77
5,7,184~7,7,184
6,8,68~8,8,68
0,4,19~0,7,19
1,0,164~1,2,164
1,0,252~4,0,252
8,0,166~8,1,166
7,3,252~7,3,254
8,6,216~8,8,216
1,4,259~4,4,259
5,2,18~7,2,18
0,5,123~0,7,123
3,1,69~3,1,71
7,0,72~7,3,72
3,4,103~5,4,103
2,3,224~2,5,224
4,1,215~4,3,215
2,5,114~2,5,117
3,5,221~5,5,221
5,0,55~7,0,55
7,2,84~7,5,84
0,8,243~2,8,243
5,6,147~5,6,150
0,2,3~1,2,3
9,6,167~9,6,169
4,3,77~4,6,77
6,5,12~7,5,12
1,8,185~3,8,185
4,1,100~4,5,100
4,4,219~4,7,219
7,5,206~7,7,206
3,4,221~6,4,221
1,2,18~2,2,18
3,4,145~3,7,145
3,7,236~4,7,236
3,5,249~6,5,249
9,7,221~9,9,221
3,4,26~3,5,26
4,2,226~6,2,226
1,5,113~3,5,113
1,4,90~1,6,90
1,4,198~1,4,200
8,2,135~8,4,135
7,9,267~9,9,267
7,2,58~9,2,58
0,2,192~1,2,192
4,2,177~7,2,177
6,1,57~9,1,57
6,0,103~6,3,103
2,5,264~4,5,264
2,3,113~2,4,113
3,7,201~6,7,201
0,9,238~0,9,240
9,4,31~9,6,31
2,9,21~2,9,21
0,7,166~0,8,166
2,6,216~4,6,216
8,6,66~8,9,66
6,5,54~6,7,54
3,6,133~6,6,133
1,2,163~4,2,163
0,8,116~3,8,116
4,2,77~5,2,77
1,0,122~4,0,122
3,1,173~3,4,173
9,5,50~9,8,50
7,6,241~7,7,241
5,7,51~5,7,54
4,7,16~6,7,16
7,4,189~7,6,189
6,6,173~6,6,175
7,7,168~7,9,168
6,1,1~6,3,1
5,5,52~8,5,52
0,1,256~2,1,256
4,7,98~4,8,98
0,2,153~1,2,153
4,9,51~6,9,51
9,7,242~9,9,242
7,3,208~7,3,210
8,6,266~8,9,266
9,1,159~9,4,159
1,4,24~1,5,24
7,5,193~7,5,194
7,5,131~9,5,131
7,0,151~7,1,151
5,4,85~5,5,85
6,5,219~8,5,219
6,2,136~6,5,136
4,7,95~6,7,95
9,4,139~9,5,139
5,7,20~5,7,22
1,8,236~2,8,236
9,2,93~9,4,93
3,5,219~3,6,219
9,0,27~9,2,27
2,0,190~2,2,190
1,7,34~3,7,34
4,3,198~4,6,198
4,2,63~4,4,63
3,3,143~3,4,143
0,5,16~2,5,16
2,1,95~2,2,95
5,8,232~6,8,232
5,7,36~5,7,38
0,9,95~2,9,95
7,3,189~8,3,189
5,9,192~7,9,192
6,7,90~6,9,90
5,4,160~5,5,160
7,1,16~7,1,17
8,8,219~9,8,219
6,2,227~6,2,231
4,3,86~4,3,89
3,2,245~3,4,245
5,7,166~5,7,169
0,6,98~2,6,98
1,1,48~1,3,48
9,2,72~9,5,72
6,1,152~6,5,152
5,6,60~5,6,61
4,6,156~4,8,156
9,0,28~9,2,28
1,2,36~2,2,36
5,8,277~6,8,277
9,6,33~9,8,33
5,7,11~5,9,11
2,0,74~4,0,74
8,0,209~8,1,209
6,2,75~6,5,75
2,5,181~2,7,181
0,9,212~2,9,212
1,9,88~1,9,90
4,8,29~7,8,29
4,4,232~4,4,233
8,2,245~8,5,245
3,6,177~3,9,177
2,2,179~4,2,179
3,4,68~3,4,70
6,0,83~6,1,83
8,2,11~8,3,11
6,7,62~8,7,62
5,4,51~7,4,51
0,6,75~1,6,75
7,3,40~9,3,40
6,1,257~7,1,257
9,3,136~9,4,136
9,1,85~9,4,85
8,3,132~8,5,132
0,3,248~3,3,248
7,0,97~9,0,97
8,3,252~8,4,252
4,4,38~6,4,38
3,8,176~5,8,176
4,1,71~5,1,71
5,1,109~5,1,109
3,1,84~6,1,84
4,0,246~6,0,246
3,3,241~3,6,241
7,0,91~7,2,91
7,3,192~9,3,192
0,4,67~2,4,67
9,2,201~9,4,201
1,6,170~1,7,170
4,9,75~6,9,75
6,9,232~8,9,232
2,1,21~2,2,21
1,6,212~3,6,212
0,3,254~1,3,254
1,5,277~3,5,277
0,1,260~0,4,260
1,3,260~1,6,260
4,3,252~6,3,252
4,0,199~4,3,199
7,0,190~9,0,190
2,7,55~2,9,55
2,4,206~2,7,206
6,8,176~9,8,176
4,5,108~4,5,110
7,0,141~9,0,141
5,4,203~5,7,203
8,5,118~8,8,118
7,6,268~7,7,268
7,2,244~7,4,244
3,7,198~3,7,198
6,4,214~8,4,214
4,2,183~6,2,183
4,2,142~4,4,142
0,2,127~2,2,127
7,2,11~7,2,13
1,5,193~5,5,193
6,5,94~9,5,94
