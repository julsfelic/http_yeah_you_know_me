class Game
  attr_accessor :guessed_count, :guessed_num
  attr_reader :goal

  def initialize
    @goal          = 25
    @guessed_count = 0
    @guessed_num   = nil
  end

  def guess_checker
    guessed_num <=> goal
  end

  def run_game
    guess_msg = "<p>Guess count: #{guessed_count}</p>"
    check_result = guess_checker
    if check_result == -1
      guess_msg += "<p>Guess was too low!</p>"
    elsif check_result == 0
      guess_msg += "<p>You guessed correctly! (Game reset)</p>"
    elsif check_result == 1
      guess_msg += "<p>Guess was too high!</p>"
    else
      guess_msg
    end
  end

  def give_guess(response)
    @guessed_num    = response.guess
    @guessed_count += 1
    response.status_code = "302 Found"
  end
end
