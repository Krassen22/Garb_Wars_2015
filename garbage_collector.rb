require 'open-uri'
require 'net/http'


HOST_URL = "http://192.168.86.128:8080/"
COMPANY_NAME = "Krassen_Angelov"

def get_objects id
  edges = Array.new
  url = HOST_URL + "/api/sector/#{id}/objects"
  # puts "All objects from sector #{id}."
  # p url; puts "\n"
  response = open(url).read
  # p response
  edges = response.lines
end

def get_roots id
  roots = Array.new
  int_str_roots = Array.new
	url = HOST_URL + "/api/sector/#{id}/roots"
  # puts "All roots from sector #{id}."
	# p url; puts "\n"
  response = open(url).read
  # p response
  roots = response.lines
  roots.each do |root|
    root = root.to_i.to_s
    int_str_roots << root
  end
  return int_str_roots
end

def vertices_map edges
  vertices_hash = Hash.new{|h,k| h[k] = []}
  vertex = nil
  edges.each do |edge|
    f_vertex = edge.split(" ")[0]
    s_vertex = edge.split(" ")[-1]
    if vertex != f_vertex
      vertex = f_vertex
    end
    vertices_hash[vertex] << s_vertex
  end
  return vertices_hash
end

class Array2D < Array
  def [](n)
    self[n]=Array.new if super(n) == nil
    super n
  end
end

def extirpate_roots all_hash_vertices, all_roots, id
  #for id in 1..10
    cheker1 = 0
    cheker2 = 0
    all_roots[id].each do |root|
      all_hash_vertices[id].each do |key, value|
        if root == key
          # p "ID #{id}"
          # p root
          all_roots[id] << value
          all_roots[id].flatten!
          all_hash_vertices[id].delete key
          cheker1 = 1
        end
        value.each do |v|
          if root.eql? v
            value.delete(root)
            cheker2 = 1
          end
        end
      end
    end
    return all_hash_vertices if cheker1 == 0 && cheker2 == 0
  #end
  extirpate_roots all_hash_vertices, all_roots, id
end

# def find_start_points all_hash_vertices, id
#   cheker = 0
#   index = 0
#   start_points = Array2D.new
#   all_hash_vertices[id].each do |key1, value1|
#     all_hash_vertices[id].each do |key2, value2|
#       value2.each do |v2|
#         if key1 == v2
#          cheker = 1
#          break
#         end
#       end
#       break if cheker == 1
#     end
#     if cheker == 0
#       start_points[index] << key1
#       p start_points
#       puts "------------------"
#       index += 1
#     end
#     cheker = 0
#   end
#   return start_points
# end
#
# def create_trajectories all_hash_vertices, trajectories, id
#   p "Create trajectories -------------------------------"
#   p trajectories
#   trajectories.each do |trajectory| #[123, 1342, 42]
#     p trajectory
#     trajectory.each do |tra| # 123... 1342 .. 42
#       #p tra
#       all_hash_vertices[id][tra].each do |value|
#         p "VALUE"
#         p value
#         break
#       end
#     end
#   end
#   p trajectories
# end
#
# $asdf = 0

# def recurtion_trajectories all_hash_vertices, id, trajectories, index, chosen_one, trajectories_safer
#   cheker = 0
#   index_safer = 0
#   all_hash_vertices[id].each do |key, value|
#     #p value.class
#     # if value.any?
#     #   cheker = 1
#     #   break
#     # end
#   end
#   $asdf += 1
#   return if $asdf == 10
#
#   for idx in 0..(trajectories.count-1)
#     # all_hash_vertices[id].each do |key, value|
#     #   if trajectories[idx][chosen_one[idx]] == key
#     #     value.each do |element|
#     #       if element == value[0] || element == nil
#     #         trajectories_safer[index_safer] = trajectories[idx]
#     #         trajectories.delete(trajectories[idx])
#     #         index_safer += 1
#     #       end
#     #     end
#     #     trajectories[idx] << value[0]
#     #     #p value
#     #     #value.delete(value[0])
#     #     #p value
#     #     chosen_one[idx] += 1
#     #     break
#     #   end
#     # end
#     all_hash_vertices[id].each do |key, value|
#       value.each do |v|
#         if trajectories[idx][chosen_one[idx]] == v
#           trajectories[idx].insert(0, key)
#           value.delete(v) #???
#         end
#         break
#       end
#     end
#   end
#   recurtion_trajectories all_hash_vertices, id, trajectories, index, chosen_one, trajectories_safer
#
# end

# def create_trajectories2 all_hash_vertices, id
#   trajectories = Array2D.new
#   trajectories_safer = Array2D.new
#   index = 0
#   chosen_one = Array.new
#   all_hash_vertices[id].each do |key, value|
#     value.each do |v|
#       p v
#       trajectories[index] << v
#       index += 1
#     end
#   end
#   p index
#   for i in 0..(trajectories.count-1)
#     chosen_one[i] = 0
#   end
#   p "The Chosen One"
#   p chosen_one
#
#   recurtion_trajectories all_hash_vertices, id, trajectories, index, chosen_one, trajectories_safer
#   puts
#   p "trajectories_safer"
#   p trajectories_safer
#   p "trajectories"
#   p trajectories
#   return trajectories
# end
$a = 0
def recurtion_trajectories all_hash_vertices, id, trajectories
  $a += 1
  all_hash_vertices[id].each do |key, value|
    # print key
    # print " -> "
    # print value
    # puts
    value.each do |v|
      for idx in 0..(trajectories.count-1)
        if trajectories[idx][0] == v
          trajectories[idx].insert(0, key)
          value.delete(v)
          # It's fine
          # p "-----------------"
          # p value
          # p v
          # #p trajectories
          # p "-----------------"
        end
      end
    end
    # p all_hash_vertices[id]
    # p trajectories
    all_hash_vertices[id].keys do |key|
      trajectories[idx].push(key)

    end
    # p trajectories
    #return "asdf" if $a == 10
    #recurtion_trajectories all_hash_vertices, id, trajectories
  end
end

def create_trajectories2 all_hash_vertices, id
  trajectories = Array2D.new
  #trajectories_safer = Array2D.new
  chosen_one = Array.new
  index = 0
  all_hash_vertices[id].each do |key, value|
    value.each do |v|
      # p v
      trajectories[index] << v
      index += 1
    end
  end
  # p trajectories
  # p index
  # for i in 0..(trajectories.count-1)
  #   chosen_one[i] = 0
  # end
  # p "The Chosen One"
  # p chosen_one

  recurtion_trajectories all_hash_vertices, id, trajectories
  # puts
  # p "trajectories_safer"
  # #p trajectories_safer
  # p "trajectories"
  # p trajectories
  return trajectories
end


def print_all_hash_vertices all_hash_vertices, id
  all_hash_vertices[id].each do |key, value|
    print "#{key} -> "
    print value
    puts "\n"
  end
end

def send_trajectory trajectory, sector
  uri = URI("#{ HOST_URL }/api/sector/#{ sector }/company/#{ COMPANY_NAME }/trajectory")
  Net::HTTP.post_form(uri, 'trajectory' => trajectory)
end

all_objects = Array2D.new
all_roots = Array2D.new
all_hash_vertices = Array.new { Hash.new }
new_all_hash_vertices = Array2D.new { Hash.new }
trajectories = Array2D.new

while(1) do
  for id in 1..10
    # Взима всички edges от сървъра
    all_objects[id] = get_objects id
    #p all_objects[id]
    # Взима всички roots от сървъра
    all_roots[id] = get_roots id
    #p all_roots[id]
    # Съставя масив от всички хашове в който, като key е vertex,
    # а като value е масив от vertices, към които гореспоменатия key сочи.
    all_hash_vertices[id] = vertices_map all_objects[id]



# Служи за принтиране на всички хашове в сектор.
# print_all_hash_vertices all_hash_vertices, id


# Връща 10 масива, като всеки има в себе си масив от хашове
# без roots в него.

    new_all_hash_vertices = extirpate_roots all_hash_vertices, all_roots, id
    # p new_all_hash_vertices
# start_points = find_start_points all_hash_vertices, id
# create_trajectories all_hash_vertices, start_points, id

    trajectories[id] = create_trajectories2 new_all_hash_vertices, id
    # p trajectories[id]
    trajectories[id] = trajectories[id].sort_by {|x| x.length}
    trajectories[id].reverse!
#end
# create_trajectories all_hash_vertices, start_points, id
  # Служи за принтиране на всички хашове в сектор.
  #print_all_hash_vertices new_all_hash_vertices, id


# Трябва да върща траекториите подходящи за пращане към сървъра.
# Трябва да прочетеш условието на заданието!
# create_trajectory new_all_hash_vertices, id, trajectory_array

# Това не ти трябва за направата на траекторията!

#for id in 1..10
    t_string = Array.new
    #puts
    #p "SECTOR: #{id}"
    #p "-----------------------------------------------------"
    #p trajectories[id]
    for i in 0..(trajectories[id].count-1)
      t_string[i] = ""
    end
    index = 0
    trajectories[id].each do |trajec|
      trajec.each do |element|
        t_string[index].insert(-1, "#{element} ")
      end
      index += 1
    end
    t_string.each do |lts|
      t_string.each do |sts|
        if lts.include? sts
          t_string.delete(sts)
        end
      end
    end
    next if t_string == []
    # t_string.each do |ts|
    #   send_trajectory ts, id
    #   t_string.delete(ts)
    # end
    send_trajectory t_string[0], id
    t_string.delete(t_string[0])
    # p t_string
  end
  #break if trajectories == []
end
# p "///////////////////////////////"
# trajectories = trajectories.sort_by {|x| x.length}
# trajectories.reverse!
# t_string = Array.new
# for i in 0..(trajectories.count-1)
#   t_string[i] = ""
# end
# index = 0
#
# trajectories.each do |trajec|
#   trajec.each do |element|
#     t_string[index].insert(-1, "#{element} ")
#   end
#   index += 1
# end
#
# t_string.each do |lts|
#   t_string.each do |sts|
#     if lts.include? sts
#       t_string.delete(sts)
#     end
#   end
# end
# # while(1) do
# # p t_string
# # t_string.each do |ts|
# #   send_trajectory ts, id
# #   t_string.delete(ts)
# # end
# # end


#   send_trajectory t_string, id
#p new_all_hash_vertices[id]
  # new_all_hash_vertices[id].each do |key, value|
  #   value.each do |v|
  #     send_trajectory "#{key} #{v}", id
  #   end
  # end
