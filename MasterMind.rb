# rubocop:disable Metrics/MethodLength
# Game-Logic:
#
# Code-Colors: Red, Blue, Green, Yellow, Purple, Orange
# Key-Colors: White, Black
#
# Initialize: Computer randomly chooses a color (rand:1-6) in each of 4 slots
# Initialize: Choose # of turns
#
# GameLoop: Enter a guess in form 'RGYP'
# GameLoop: Check guess against the known Code
# GameLoop: Provide feedback "You have X precise guesses and Y correct colors in the wrong slots"
# GameLoop: Guess again

VALID_INPUTS = ['R', 'G', 'O', 'Y', 'P', 'B']
MAX_TURNS = 12

def generate_random_code
  code = ''
  4.times do
    code += VALID_INPUTS[rand(6)]
  end

  code
end

# Takes in guess, a string of form 'RGYP', compares to code, returns [perfectCount, imperfectCount] array
def evaluate_guess(guess, code)
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

def valid_code_input?(inputstr)
  inputstr.split('').each do |item|
    unless VALID_INPUTS.include?(item)
      puts "Error! Only acceptable colors are #{VALID_INPUTS}" 
      return false
    end
  end

  true
end

def accept_player_code
  loop do
    puts "Input code in form 'RGBY' (choosing from #{VALID_INPUTS})>>"
    input_string = gets.chomp
    if input_string.length != 4
      puts "Error! Input must be of form 'RGBY' exactly 4 characters long."
      next
    end

    next unless valid_code_input?(input_string)

    return input_string
  end
end

def AI_generate_all_combinations
  combinations = []
  VALID_INPUTS.each do |char1|
    VALID_INPUTS.each do |char2|
      VALID_INPUTS.each do |char3|
        VALID_INPUTS.each do |char4|
          combinations << "#{char1}#{char2}#{char3}#{char4}"
        end
      end
    end
  end

  combinations
end

def AI_reduce_combinations_from_result(previous_guess, previous_feedback, current_combinations)
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

def AI_make_guess(previous_guess, current_combinations)
  if previous_guess == ''
    firstChar = VALID_INPUTS[rand(6)]
    secondChar = VALID_INPUTS[rand(6)]

    while firstChar == secondChar
      secondChar = valid_code_input?[rand(6)]
    end

    return "#{firstChar}#{firstChar}#{secondChar}#{secondChar}"
  end

  return current_combinations[rand(current_combinations.size)]
end

def player_as_codebreaker_game
  ai_code = generate_random_code
  turn_count = 0
  loop do
    player_guess = accept_player_code
    guess_eval = evaluate_guess(player_guess, ai_code)
    turn_count += 1

    if guess_eval[0] == 4
      puts "Congratulations code-breaker, you guessed the code in #{turn_count} turns!"
      return turn_count
    elsif turn_count == MAX_TURNS
      puts "Oh no code-breaker, you have failed to guess the code in #{MAX_TURNS} turns! Game over."
      return turn_count
    else
      puts "Your guess had #{guess_eval[0]} perfect matches and #{guess_eval[1]} imperfect matches."
    end
  end
end

def AI_as_codebreaker_game
  player_code = accept_player_code
  puts "Confirmed, your secret code is #{player_code}."
  valid_combinations = AI_generate_all_combinations()
  guess_num = 1
  guess = ''

  loop do
    guess = AI_make_guess(guess, valid_combinations)
    feedback = evaluate_guess(guess, player_code)
    puts "Guess ##{guess_num}: #{guess} had #{feedback[0]} perfect matches and #{feedback[1]} imperfect matches."

    if feedback[0] == 4
      puts "AI was able to guess your code in #{guess_num} turns!"
      return guess_num
    elsif guess_num == MAX_TURNS
      puts 'Congrulations! The AI was unable to guess your code before turns ran out.'
      return guess_num
    else
      guess_num += 1
      valid_combinations = AI_reduce_combinations_from_result(guess, feedback, valid_combinations)
      sleep(1)
    end
  end
end
# rubocop:enable Metrics/MethodLength

AI_as_codebreaker_game()
