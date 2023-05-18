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

def generate_random_code()
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

def valid_input?(inputstr)
  inputstr.split('').each do |item|
    unless VALID_INPUTS.include?(item)
      puts "Error! Only acceptable colors are #{VALID_INPUTS}" 
      return false
    end
  end

  true
end

def accept_input()
  loop do
    puts "Code-breaker, guess in form 'RGBY' (choosing from #{VALID_INPUTS})>>"
    input_string = gets.chomp
    if input_string.length != 4
      puts "Error! Input must be of form 'RGBY' exactly 4 characters long."
      next
    end

    next unless valid_input?(input_string)

    return input_string
  end
end

ai_code = generate_random_code
turn_count = 0
loop do
  player_guess = accept_input
  guess_eval = evaluate_guess(player_guess, ai_code)
  turn_count += 1

  if guess_eval[0] == 4
    puts "Congratulations code-breaker, you guessed the code in #{turn_count} turns!"
    break
  elsif turn_count == MAX_TURNS
    puts "Oh no code-breaker, you have failed to guess the code in #{MAX_TURNS} turns! Game over."
    break
  else
    puts "Your guess had #{guess_eval[0]} perfect matches and #{guess_eval[1]} imperfect matches."
  end
end
