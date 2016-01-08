require "test_helper"

class ServerAcceptanceTest < Minitest::Test
  def self.test_order
    :alpha
  end

  def test_gives_a_successfull_response
    response = Hurley.get("http://127.0.0.1:9292")

    assert response.success?
  end

  def test_outputs_hello_world_when_hello_is_requested
    clear_count
    response = Hurley.get("http://127.0.0.1:9292/hello")
    expected = wrapper("<p>Hello, World! (0)</p>")

    assert_equal expected, response.body
  end

  def test_increments_hello_world_count_by_one_after_every_request
    clear_count
    client = Hurley::Client.new "http://127.0.0.1:9292"
    client.get "/hello"
    client.get "/hello"
    client.get "/hello"
    response = client.get "/hello"
    expected = wrapper("<p>Hello, World! (3)</p>")

    assert_equal expected, response.body
  end

  def test_only_increments_for_hello_world_request
    clear_count
    client = Hurley::Client.new "http://127.0.0.1:9292"
    client.get "/hello"
    client.get "/hello"
    response = client.get "/hello"
    expected = wrapper("<p>Hello, World! (2)</p>")

    assert_equal expected, response.body

    client.get "/"
    client.get "/"
    response = client.get "/hello"
    expected = wrapper("<p>Hello, World! (3)</p>")

    assert_equal expected, response.body
  end

  def test_outputs_formatted_date_when_datetime_is_requested
    response = Hurley.get("http://127.0.0.1:9292/datetime")
    expected_time = Time.now.strftime("%I:%M%p on %A, %B %d, %Y")
    expected = wrapper("<p>#{expected_time}</p>")

    assert_equal expected, response.body
  end

  def test_outputs_known_word_when_word_search_path_is_requested
    response = Hurley.get("http://127.0.0.1:9292/word_search?word=pizza")
    expected = wrapper("<p>pizza is a known word</p>")

    assert_equal expected, response.body
  end

  def test_outputs_not_known_when_word_search_path_is_requested
    response = Hurley.get("http://127.0.0.1:9292/word_search?word=centower")
    expected = wrapper("<p>centower is not a known word</p>")

    assert_equal expected, response.body
  end

  def test_outputs_good_luck_when_post_to_start_game
    response = Hurley.post("http://127.0.0.1:9292/start_game")
    expected = wrapper("<p>Good luck!</p>")

    assert_equal expected, response.body
  end

  def test_outputs_zero_guesses_when_we_get_game
    Hurley.post("http://127.0.0.1:9292/start_game")
    response = Hurley.get("http://127.0.0.1:9292/game")
    expected = wrapper("<p>Guess count: 0</p>")

    assert_equal expected, response.body
  end
end
