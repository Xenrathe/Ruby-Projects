RESET_COLOR = "\e[0m"
RED = "\e[38;2;255;0;0m"
GREEN = "\e[1m\e[32m"
YELLOW = "\e[1m\e[33m"
BLUE = "\e[1m\e[34m"
ORANGE = "\e[38;2;255;150;27m"
PURPLE = "\e[1m\e[35m"

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
  elsif input_string.length != hidden_word.length && input_string.downcase != 'save'
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

def hidden_word_progress(letter_guesses, hidden_word)
  hidden_word.split('').map do |character|
    if letter_guesses.include?(character)
      character
    else
      '_'
    end
  end
end

def letter_guess_feedback(letter_guess, letter_guesses, hidden_word, wrong_guesses)
  if hidden_word.include?(letter_guess)
    puts "\n#{GREEN}Correct guess!#{RESET_COLOR}"
  elsif letter_guess != '0'
    puts "\n#{ORANGE}Incorrect guess!#{RESET_COLOR}"
  end

  puts draw_hangman(wrong_guesses)
  puts "\n Guesses: #{letter_guesses}"
  puts "#{hidden_word_progress(letter_guesses, hidden_word).join(" ")}\n\n"
end

def draw_hangman(wrong_guesses)
  [
  '    +---+',
  '    |   |',
  "    #{wrong_guesses >= 1 ? 'O' : ' '}   |",
  "   #{wrong_guesses >= 2 ? '/' : ' '}#{wrong_guesses >= 3 ? '|' : ' '}#{wrong_guesses >= 4 ? '\\' : ' '}  |",
  "    #{wrong_guesses >= 5 ? '|' : ' '}   |",
  "   #{wrong_guesses >= 6 ? '/' : ' '} #{wrong_guesses >= 7 ? '\\' : ' '}  |",
  '        |',
  '  ========='
  ]
end

def save_game(hidden_word, letter_guesses, wrong_guesses)
  savefile = File.open("save.sav", 'w')
  savefile.puts(hidden_word)
  savefile.puts(letter_guesses.join(','))
  savefile.puts(wrong_guesses)
  savefile.close
end

def load_game
  return false unless File.exist?("save.sav")

  savefile = File.open("save.sav", 'r')
  hidden_word = savefile.readline.chomp
  letter_guesses = savefile.readline.chomp.split(',')
  wrong_guesses = savefile.readline.chomp.to_i
  puts "#{BLUE}Save file loaded. Save file deleted.#{RESET_COLOR}\n\n"
  letter_guess_feedback('0', letter_guesses, hidden_word, wrong_guesses)
  savefile.close
  File.delete("save.sav")
  [hidden_word, letter_guesses, wrong_guesses]
end

def play_round
  wrong_guesses = 0
  letter_guesses = []
  hidden_word = choose_word_from_file(5, 12)
  
  load_info = load_game
  if load_info
    hidden_word = load_info[0]
    letter_guesses = load_info[1]
    wrong_guesses = load_info[2]
  end

  loop do
    input_string = accept_guess_input("Input guess-word, letter, or 'save'>>", hidden_word, letter_guesses).downcase

    if input_string.length == 1
      letter_guesses.push(input_string)
      wrong_guesses += 1 unless hidden_word.include?(input_string)
      letter_guess_feedback(input_string, letter_guesses, hidden_word, wrong_guesses)
    elsif input_string.downcase == 'save'
      save_game(hidden_word, letter_guesses, wrong_guesses)
      puts "Game saved! Come back later."
      break
    elsif input_string == hidden_word
      puts "Congraulations, you guessed the word with only #{wrong_guesses} wrong guesses!"
      break
    else
      puts "Sorry, your guess was not correct."
      wrong_guesses += 1
      draw_hangman(wrong_guesses)
      puts "\n Guesses: #{letter_guesses}"
      puts hidden_word(letter_guesses, hidden_word).join(" ")
    end

    if (wrong_guesses >= 7)
      puts "Uh oh, you've run out of guesses to guess the hidden-word: #{hidden_word}! You're hanged!"
      break
    end
  end
end

play_round