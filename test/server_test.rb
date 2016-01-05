require 'test_helper'
require 'server'

class ServerTest < Minitest::Test

  def test_can_create_an_instance
    server = Server.new
    assert_instance_of Server, server
  end

  def test_accepts_a_port_as_an_init_argument
    server = Server.new(9293)

    assert server
  end

end
