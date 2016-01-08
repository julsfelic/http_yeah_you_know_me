require "test_helper"
require "server"

class RequestHandlerTest < Minitest::Test

  def test_normalizes_requests
    server = Server.new
    parsed_request = ["GET / HTTP/1.1",
                      "User-Agent: Hurley v0.2",
                      "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
                      "Accept: */*",
                      "Connection: close",
                      "Host: 127.0.0.1:9292"]
    normalized_request = server.normalized_request(parsed_request)
    expected = [["Accept:", "*/*"],
                ["GET", "/", "HTTP/1.1"],
                ["Host:", "127.0.0.1:9292"]]

    assert_equal expected, normalized_request
  end
end
