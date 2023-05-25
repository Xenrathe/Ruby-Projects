def fibs(number_count)
  fibs_seq = [0, 1]
  count = 2
  while count <= number_count
    fibs_seq.push(fibs_seq[count - 2] + fibs_seq[count - 1])
    count += 1
  end
  fibs_seq.slice(0, number_count)
end

# Recursive-version, single line
def fibs_rec(num, array)
  array.push(num == 2 ? 1 : fibs_rec(num - 1, array).slice(num - 3, 2).sum)
end

print "#{fibs_rec(3, [0])}\n"


