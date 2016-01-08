require "test_helper"
require "server"

class ServerTest < Minitest::Test
  def test_resets_count
    server = Server.new(9293)
    server.hello_count   = 3
    server.request_count = 3
    server.reset_count

    assert_equal 0, server.hello_count
    assert_equal 0, server.request_count
  end
end
