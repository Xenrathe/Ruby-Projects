def fibs(number_count)
  fibs_seq = [0, 1]
  count = 2
  while count <= number_count
    fibs_seq.push(fibs_seq[count - 2] + fibs_seq[count - 1])
    count += 1
  end
  fibs_seq.slice(0, number_count)
end

# Recursive-version
# Single line because challenged myself to do so
# Normally I would rank readability over concision
def fibs_rec(num, num_list)
  num == 1 ? [0] : num_list.push(num < 3 ? num - 1 : fibs_rec(num - 1, num_list).slice(num - 3, 2).sum)
end

puts "Fibonnaci of length 1: #{fibs_rec(1, [0])}\n"
puts "Fibonnaci of length 2: #{fibs_rec(2, [0])}\n"
puts "Fibonnaci of length 9: #{fibs_rec(9, [0])}\n"

def merge_sort(array)
  return array if array.count == 1

  # Split array into 2 'equal' size subarrays
  s1 = array.slice(0, array.count / 2)
  s2 = array.slice(array.count / 2, array.count - array.count / 2)

  # Return sorted sub-arrays
  s1 = merge_sort(s1)
  s2 = merge_sort(s2)

  # Merge sorted sub arrays back together in proper order
  array.clear
  array.push(s1[0] < s2[0] ? s1.shift : s2.shift) while s1.count != 0 && s2.count != 0
  array.push(*s1)
  array.push(*s2)
end

num_array = [15, 3, 7, 22, 5, -11, 1, 0]
letter_array = ['b', 'q', 'n', 'a', 'a', 's', 'd']
word_array = ['apple', 'aardvark', 'zebra', 'banana', 'zeal', 'castle']
puts "#{num_array} sorts into: #{merge_sort(num_array)}"
puts "#{letter_array} sorts into: #{merge_sort(letter_array)}"
puts "#{word_array} sorts into: #{merge_sort(word_array)}"
