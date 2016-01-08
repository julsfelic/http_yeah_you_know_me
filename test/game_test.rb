require "test_helper"
require "game"
require "response"

class GameTest < Minitest::Test
  def test_can_create_instances
    game = Game.new

    assert_instance_of Game, game
  end

  def test_contains_defautl_instance_variables
    game = Game.new

    assert_equal 25, game.goal
    assert_equal 0, game.guessed_count
  end

  def test_can_check_a_guess
    game = Game.new
    game.guessed_num = 24
    assert_equal -1, game.guess_checker

    game.guessed_num = 25
    assert_equal 0, game.guess_checker

    game.guessed_num = 26
    assert_equal 1, game.guess_checker
  end

  def test_can_run_game_and_return_a_msg
    game = Game.new
    msg = game.run_game
    expected = "<p>Guess count: 0</p>"

    assert_equal expected, msg

    game.guessed_num = 24
    msg = game.run_game
    expected = "<p>Guess count: 0</p><p>Guess was too low!</p>"

    assert_equal expected, msg

    game.guessed_num = 25
    msg = game.run_game
    expected = "<p>Guess count: 0</p><p>You guessed correctly! (Game reset)</p>"

    assert_equal expected, msg

    game.guessed_num = 26
    msg = game.run_game
    expected = "<p>Guess count: 0</p><p>Guess was too high!</p>"

    assert_equal expected, msg
  end

  def test_can_accept_a_guess
    response = Response.new
    game = Game.new

    response.expects(:guess).returns(24)
    expected = "302 Found"
    status_code = game.give_guess(response)

    assert_equal expected, status_code
  end
end
