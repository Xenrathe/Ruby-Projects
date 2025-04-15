module MasterMind
  COLOR_LIST = ['R', 'G', 'O', 'Y', 'P', 'B']
  MAX_TURNS = 12
  RESET_COLOR = "\e[0m"
  RED = "\e[38;2;255;0;0m"
  GREEN = "\e[1m\e[32m"
  YELLOW = "\e[1m\e[33m"
  BLUE = "\e[1m\e[34m"
  ORANGE = "\e[38;2;255;150;27m"
  PURPLE = "\e[1m\e[35m"

  def self.color_code(original_code)
    colored_code = ""
    original_code.split('').each do |char|
      case char
      when 'R'
        colored_code += "#{RED}R#{RESET_COLOR}"
      when 'G'
        colored_code += "#{GREEN}G#{RESET_COLOR}"
      when 'O'
        colored_code += "#{ORANGE}O#{RESET_COLOR}"
      when 'Y'
        colored_code += "#{YELLOW}Y#{RESET_COLOR}"
      when 'P'
        colored_code += "#{PURPLE}P#{RESET_COLOR}"
      when 'B'
        colored_code += "#{BLUE}B#{RESET_COLOR}"
      end
    end
    colored_code
  end

  def self.generate_random_code
    code = ''
    4.times do
      code += COLOR_LIST[rand(6)]
    end

    code
  end

  # Takes in guess, a string of form 'RGYP', compares to code, returns [perfectCount, imperfectCount] array
  def self.evaluate_guess(guess, code)
    guess = guess.split('')
    code = code.split('')
    perfect_guesses = 0
    imperfect_guesses = 0
    checks = 0

    while checks < 4
      curr_index = checks - perfect_guesses
      if guess[curr_index] == code[curr_index]
        perfect_guesses += 1
        guess.delete_at(curr_index)
        code.delete_at(curr_index)
      end
      checks += 1
    end

    guess.each do |item|
      if code.include?(item)
        imperfect_guesses += 1
        code.delete_at(code.index(item))
      end
    end

    [perfect_guesses, imperfect_guesses]
  end

  def self.valid_player_input?(inputstr, valid_inputs)
    inputstr.split('').each do |item|
      unless valid_inputs.any?{ |element| element.downcase == item.downcase }
        puts "Error! Only acceptable inputs are #{valid_inputs}"
        return false
      end
    end

    true
  end

  def self.accept_player_input(prompt_string, example_input, valid_inputs)
    loop do
      # puts "Input code in form 'RGBY' (choosing from #{VALID_INPUTS})>>"
      puts prompt_string
      input_string = gets.chomp
      if input_string.length != example_input.length
        puts "Error! Input must be of form #{example_input} exactly #{example_input.length} characters long."
        next
      end

      next unless valid_player_input?(input_string, valid_inputs)

      return input_string
    end
  end

  def self.ai_generate_all_combinations
    combinations = []
    COLOR_LIST.each do |char1|
      COLOR_LIST.each do |char2|
        COLOR_LIST.each do |char3|
          COLOR_LIST.each do |char4|
            combinations << "#{char1}#{char2}#{char3}#{char4}"
          end
        end
      end
    end

    combinations
  end

  def self.ai_reduce_combinations_from_result(previous_guess, previous_feedback, current_combinations)
    perfect_guesses = previous_feedback[0]
    imperfect_guesses = previous_feedback[1]
    new_combinations = []
    matching_combinations = []

    # Step 1: Remove failed guess
    current_combinations.delete(previous_guess)

    # Step 2: Reduce combinations on the basis of imperfect_guess total color matching
    previous_guess_count = Hash.new(0)
    previous_guess.chars.each do |char|
      previous_guess_count[char] += 1
    end

    current_combinations.each do |combination|
      combination_count = Hash.new(0)
      combination.chars.each do |char|
        combination_count[char] += 1
      end

      total_match = 0
      combination_count.each do |char, count|
        total_match += [count, previous_guess_count[char]].min
      end

      new_combinations << combination if total_match == imperfect_guesses + perfect_guesses
    end

    # Step 3: Reduce combinations on the basis of exact perfect_guesses matching
    new_combinations.each do |combination|
      perfect_matches = 0
      for index in 0..3
        perfect_matches += 1 if combination[index] == previous_guess[index]
      end

      matching_combinations << combination if perfect_matches == perfect_guesses
    end

    matching_combinations
  end

  def self.ai_make_guess(previous_guess, current_combinations)
    if previous_guess == ''
      first_char = COLOR_LIST[rand(6)]
      second_char = COLOR_LIST[rand(6)]

      second_char = COLOR_LIST[rand(6)] while first_char == second_char

      return "#{first_char}#{first_char}#{second_char}#{second_char}"
    end

    return current_combinations[rand(current_combinations.size)]
  end

  def self.player_as_codebreaker_game
    ai_code = generate_random_code
    turn_count = 0
    loop do
      player_guess = accept_player_input("Input guess in form 'RGBY' (choosing from #{COLOR_LIST})>>", 'RGBY', COLOR_LIST)
      guess_eval = evaluate_guess(player_guess, ai_code)
      turn_count += 1

      if guess_eval[0] == 4
        puts "Congratulations code-breaker, you guessed #{color_code(ai_code)} in #{turn_count} turns!"
        return turn_count
      elsif turn_count == MAX_TURNS
        puts "Oh no code-breaker, you have failed to guess #{ai_code} in #{MAX_TURNS} turns! Game over."
        return turn_count + 1 # bonus point for never getting code
      else
        puts "#{color_code(player_guess)} had #{guess_eval[0]} perfect matches and #{guess_eval[1]} imperfect matches.\n\n"
      end
    end
  end

  def self.ai_as_codebreaker_game
    player_code = accept_player_input("Input secret code in form 'RGBY' (choosing from #{COLOR_LIST})>>", 'RGBY', COLOR_LIST)
    puts "Confirmed, your secret code is #{color_code(player_code)}."
    valid_combinations = ai_generate_all_combinations
    guess_num = 1
    guess = ''

    loop do
      guess = ai_make_guess(guess, valid_combinations)
      feedback = evaluate_guess(guess, player_code)
      puts "Guess ##{guess_num}: #{color_code(guess)} had #{feedback[0]} perfect matches and #{feedback[1]} imperfect matches."

      if feedback[0] == 4
        puts "AI was able to guess your code in #{guess_num} turns!"
        return guess_num
      elsif guess_num == MAX_TURNS
        puts 'Congrulations! The AI was unable to guess your code before turns ran out.'
        return guess_num + 1 # Bonus point for unguessable code
      else
        guess_num += 1
        valid_combinations = ai_reduce_combinations_from_result(guess, feedback, valid_combinations)
        sleep(1)
      end
    end
  end

  def self.initialize_game
    player_score = 0
    player_games = 0
    ai_score = 0
    ai_games = 0

    loop do
      mode = accept_player_input('For this round, do you want to play as CodeBreaker or CodeMaker? (B or M)>>', 'B', ['B','M'])
      if mode.upcase == 'M'
        puts "Okay CodeMaker it is! Let us begin!\n\n"
        player_games += 1
        player_score += ai_as_codebreaker_game
      else
        puts "Okay CodeBreaker it is! Let us begin!\n\n"
        ai_games += 1
        ai_score += player_as_codebreaker_game
      end

      puts "\n***CURRENT SCORE***"
      puts "PLAYER: #{player_score} in #{player_games} games"
      puts "AI: #{ai_score} in #{ai_games} games\n\n"
      break if accept_player_input('Do you want to play again? Y/N>>', 'Y', ['Y', 'N']).upcase == 'N'
    end
  end
end
