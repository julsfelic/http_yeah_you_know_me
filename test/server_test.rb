require 'test_helper'

class ServerTest < Minitest::Test

  def test_gives_a_successfull_response
    response = Hurley.get("http://127.0.0.1:9292")

    assert response.success?
  end

  def test_count_starts_at_zero
    clear_count
    response = Hurley.get("http://127.0.0.1:9292")
    expected = "<html><head></head><body><p>Hello, World! (0)</p></body></html>"

    assert_equal expected, response.body
  end

  def test_increments_by_one_after_every_request
    clear_count
    client = Hurley::Client.new "http://127.0.0.1:9292"
    client.get "/"
    client.get "/"
    client.get "/"
    response = client.get "/"
    expected = "<html><head></head><body><p>Hello, World! (3)</p></body></html>"

    assert_equal expected, response.body
  end
end
