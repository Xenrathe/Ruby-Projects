module Recursion

  def self.fibs(number_count)
    fibs_seq = [0, 1]
    count = 2
    while count <= number_count
      fibs_seq.push(fibs_seq[count - 2] + fibs_seq[count - 1])
      count += 1
    end
    fibs_seq.slice(0, number_count)
  end

  # Recursive-version
  # Single line because I challenged myself to do so
  # Normally I would rank readability over concision
  def self.fibs_rec(num, num_list)
    num == 1 ? [0] : num_list.push(num < 3 ? num - 1 : fibs_rec(num - 1, num_list).slice(num - 3, 2).sum)
  end

  def self.merge_sort(array)
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

  def self.prompt_merge
    puts "\nEnter a comma-separated list of numbers, letters, or words:"
    print "> "
    input = gets.chomp

    # Auto-detect type
    array = input.split(',').map(&:strip)
    sample = array.first

    sorted_array = if sample.nil?
      []
    elsif sample.match?(/\A-?\d+\z/) # integers
      merge_sort(array.map(&:to_i))
    else
      merge_sort(array)
    end

    puts "Sorted: #{sorted_array}"
  end

  def self.prompt_fibs
    puts "\nEnter the desired Fibonacci sequence length (e.g., 9):"
    print "> "
    length = gets.chomp.to_i

    if length <= 0
      puts "Please enter a positive integer."
    else
      puts "Fibonacci of length #{length}: #{fibs_rec(length, [0])}"
    end
  end

  def self.prompt
    puts "\nWelcome to the Recursive Algorithms CLI!"
    loop do
      puts "\nChoose an option:"
      puts "1. Merge Sort"
      puts "2. Fibonacci Sequence"
      puts "3. Exit"
      print "> "
      choice = gets.chomp.strip.downcase

      case choice
      when '1', 'merge sort'
        prompt_merge
      when '2', 'fibs sequence', 'fibonacci', 'fibonacci sequence'
        prompt_fibs
      when '3', 'exit'
        puts "Goodbye!"
        break
      else
        puts "Invalid option. Try again."
      end
    end
  end
end
