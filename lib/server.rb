$LOAD_PATH.unshift(File.expand_path(".", __dir__))
require "pry"
require "socket"
require 'request_handler'
require 'response_handler'

class Server
  include RequestHandler, ResponseHandler

  attr_reader :tcp_server, :client, :hello_count, :request_count, :close_server

  def initialize
    @tcp_server     = TCPServer.new(9292)
    @client         = nil
    @hello_count    = 0
    @request_count  = 0
    @close_server   = false
  end

  def send_response(args)
    client.puts args[:headers]
    client.puts args[:output]
    client.close
    tcp_server.close if close_server
  end

  def reset_count
    @hello_count = 0
    @request_count = 0
  end

  def start_server
    loop do
      @client = tcp_server.accept
      request = process_request
      process_response(request)
      @request_count += 1
      break if close_server
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
  server.start_server
end
