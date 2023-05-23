def choose_word_from_file(min_word_length, max_word_length)
  wordfile = File.open("wordlist.txt", 'r')
  word_list = []

  until wordfile.eof?
    word = wordfile.readline.gsub("\n", '')
    word_list.push(word) if word.length >= min_word_length && word.length <= max_word_length
  end

  wordfile.close
  word_list[rand(word_list.length)]
end

def valid_guess_input?(input_string, hidden_word, letter_guesses)
  if input_string.length == 1
    if input_string.count("a-zA-Z") == 0 || letter_guesses.include?(input_string)
      puts "Error! Guesses must be a letter that you have not already guessed."
      false
    else
      true
    end
  elsif input_string.length != hidden_word.length
    puts "Error! Word guesses must be of length #{hidden_word.length}"
    false
  else
    true
  end
end

def accept_guess_input(prompt_string, hidden_word, letter_guesses)
  loop do
    puts prompt_string
    input_string = gets.chomp
    next unless valid_guess_input?(input_string, hidden_word, letter_guesses)

    return input_string
  end
end

def guess_letter(letter_guesses, hidden_word)
  hidden_word.split('').map do |character|
    if letter_guesses.include?(character)
      character
    else
      '_'
    end
  end
end

def play_round
  round_num = 1
  letter_guesses = []
  hidden_word = choose_word_from_file(5, 12)
  loop do
    input_string = accept_guess_input("Input word to guess or single letter>>", hidden_word, letter_guesses)

    if input_string.length == 1
      letter_guesses.push(input_string)
      guess_letter(letter_guesses, hidden_word)
      puts guess_letter(letter_guesses, hidden_word).join(" ")
    elsif input_string == hidden_word
      puts "Congraulations, you guessed the word in #{round_num} turns!"
      break
    else
      puts "Sorry, your guess was not correct."
    end

    round_num += 1
  end
end

play_round