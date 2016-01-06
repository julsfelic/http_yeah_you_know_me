require 'test_helper'

class ServerTest < Minitest::Test

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
    # going to need another helper for clearing request count
    response = Hurley.get("http://127.0.0.1:9292/shutdown")
    expected = "<html><head></head><body><p>Total Requests: 1</p></body></html>"

    assert_equal expected, response.body
  end

  def test_increments_total_requests_after_each_requests
    skip
    client = Hurley::Client.new "http://127.0.0.1:9292"
    client.get "/"
    client.get "/hello"
    client.get "/datetime"
    response = client.get ""
  end
end
