require 'test_helper'

class ServerTest < Minitest::Test

  def test_gives_a_successfull_response
    response = Hurley.get("http://127.0.0.1:9292")

    assert response.success?
  end

  def test_hello_world_count_starts_at_zero
    skip
    clear_count
    response = Hurley.get("http://127.0.0.1:9292")
    expected = "<html><head></head><body><p>Hello, World! (0)</p></body></html>"

    assert_equal expected, response.body
  end

  def test_hello_world_count_increments_by_one_after_every_request
    skip
    clear_count
    client = Hurley::Client.new "http://127.0.0.1:9292"
    client.get "/"
    client.get "/"
    client.get "/"
    response = client.get "/"
    expected = "<html><head></head><body><p>Hello, World! (3)</p></body></html>"

    assert_equal expected, response.body
  end

  def test_outputs_formatted_diagnostic
    response = Hurley.get("http://127.0.0.1:9292")
    expected = "<html><head></head><body>" +
               "<pre>" +
               "Verb: POST\n" +
               "Path: /\n" +
               "Protocol: HTTP/1.1\n" +
               "Host: 127.0.0.1\n" +
               "Port: 9292\n" +
               "Origin: 127.0.0.1\n" +
               "Accept: text/html,application/xhtml+xml,application/xml;" +
               "q=0.9,image/webp,*/*;q=0.8" +
               "</pre></body></html>"

    assert_equal expected, response.body
  end
end
