$LOAD_PATH.unshift(File.dirname(__FILE__))
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
  end

  def reset_count
    @hello_count = 0
    @request_count = 0
  end

  def start_server
    loop do
      @client = tcp_server.accept
      process_response(process_request)
      @request_count += 1
      break if close_server
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
  server.start_server
end
