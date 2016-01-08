require "test_helper"
require "response"

class ResponseTest < Minitest::Test
  def test_can_create_instances
    response = Response.new

    assert_instance_of Response, response
  end

  def test_contains_default_instance_variables
    response = Response.new

    assert_equal "200 ok", response.status_code
    assert_equal nil, response.guess
  end

  def test_processes_lines_and_returns_self
    response = Response.new
    request_lines = [["Accept:", "*/*"],
                     ["GET", "/", "HTTP/1.1"],
                     ["Host:", "127.0.0.1:9292"]]
    same_response = response.process_lines(request_lines)

    assert_equal response, same_response
  end

  def test_builds_output
    response = Response.new
    expected = wrapper("Hello!")

    assert_equal expected, response.build_output("Hello!")
  end

  def test_builds_headers
    response = Response.new
    expected = ["HTTP/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: 10"].join("\r\n") + "\r\n\r\n"

    assert_equal expected, response.build_headers(10)
  end
end
