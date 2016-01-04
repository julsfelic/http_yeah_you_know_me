require 'test_helper'
require 'server'

class ServerTest < Minitest::Test

  def test_can_create_an_instance
    server = Server.new
    assert_instance_of Server, server
  end

end
