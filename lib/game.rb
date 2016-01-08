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
end
