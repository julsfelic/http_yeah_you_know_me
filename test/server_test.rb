require 'test_helper'

class ServerTest < Minitest::Test

  def self.test_order
    :alpha
  end

  def test_gives_a_successfull_response
    response = Hurley.get("http://127.0.0.1:9292")

    assert response.success?
  end

  def test_outputs_formatted_diagnostic_when_root_is_requested
    client = Hurley::Client.new "http://127.0.0.1:9292"
    client.header[:accept] = "text/html,application/xhtml+xml,application/xml;" \
                             "q=0.9,image/webp,*/*;q=0.8"
    response = client.get "/"
    # set accept before response
    expected = "<html><head></head><body>" \
               "<pre>" \
               "Verb: GET\n" \
               "Path: /\n" \
               "Protocol: HTTP/1.1\n" \
               "Host: 127.0.0.1\n" \
               "Port: 9292\n" \
               "Origin: 127.0.0.1\n" \
               "Accept: text/html,application/xhtml+xml,application/xml;" \
               "q=0.9,image/webp,*/*;q=0.8" \
               "</pre></body></html>"

    assert_equal expected, response.body
  end

  def test_outputs_hello_world_when_hello_is_requested
    clear_count
    response = Hurley.get("http://127.0.0.1:9292/hello")
    expected = "<html><head></head><body><p>Hello, World! (0)</p></body></html>"

    assert_equal expected, response.body
  end

  def test_increments_hello_world_count_by_one_after_every_request
    clear_count
    client = Hurley::Client.new "http://127.0.0.1:9292"
    client.get "/hello"
    client.get "/hello"
    client.get "/hello"
    response = client.get "/hello"
    expected = "<html><head></head><body><p>Hello, World! (3)</p></body></html>"

    assert_equal expected, response.body
  end

  def test_only_increments_for_hello_world_request
    clear_count
    client = Hurley::Client.new "http://127.0.0.1:9292"
    client.get "/hello"
    client.get "/hello"
    response = client.get "/hello"
    expected = "<html><head></head><body><p>Hello, World! (2)</p></body></html>"

    assert_equal expected, response.body

    client.get "/"
    client.get "/"
    response = client.get "/hello"
    expected = "<html><head></head><body><p>Hello, World! (3)</p></body></html>"

    assert_equal expected, response.body
  end

  def test_outputs_formatted_date_when_datetime_is_requested
    response = Hurley.get("http://127.0.0.1:9292/datetime")
    expected_time = Time.now.strftime("%I:%M%p on %A, %B %d, %Y")
    expected = "<html><head></head><body><p>#{expected_time}</p></body></html>"

    assert_equal expected, response.body
  end

  def test_outputs_total_requests_when_shutdown_is_requested
    skip
    clear_count
    response = Hurley.get("http://127.0.0.1:9292/shutdown")
    expected = "<html><head></head><body><p>Total Requests: 1</p></body></html>"

    assert_equal expected, response.body
  end

  def test_increments_total_requests_after_each_request
    skip
    clear_count
    client = Hurley::Client.new "http://127.0.0.1:9292"
    client.get "/"
    client.get "/hello"
    client.get "/datetime"
    response = client.get "/shutdown"
    expected = "<html><head></head><body><p>Total Requests: 4</p></body></html>"

    assert_equal expected, response.body
  end

  def test_server_shuts_down_after_a_shutdown_request
    client = Hurley::Client.new "http://127.0.0.1:9292"
    client.get "/shutdown"

    assert_raises Hurley::ConnectionFailed do
      client.get "/hello"
    end
  end

  def test_outputs_known_word_when_word_search_path_is_requested
    response = Hurley.get("http://127.0.0.1:9292/word_search?word=pizza")
    expected = "<html><head></head><body><p>pizza is a known word</p></body></html>"
    assert_equal expected, response.body
  end

  def test_outputs_not_known_when_word_search_path_is_requested
    response = Hurley.get("http://127.0.0.1:9292/word_search?word=centower")
    expected = "<html><head></head><body><p>centower is not a known word</p></body></html>"
    assert_equal expected, response.body
  end
end
