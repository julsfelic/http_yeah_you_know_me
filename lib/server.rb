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
  # Server
  def send_response(args)
    client.puts args[:headers]
    client.puts args[:output]
    client.close
    # tcp server close if some value equal true
    tcp_server.close if close_server
  end
  # Server
  def reset_count
    @hello_count = 0
    @request_count = 0
  end
  # ResponseHandler
  def diagnostic_template(normalized_lines)
    "<pre>" \
      "Verb: #{normalized_lines[1][0]}\n" \
      "Path: #{normalized_lines[1][1]}\n" \
      "Protocol: #{normalized_lines[1][2]}\n" \
      "Host: #{normalized_lines.last[1].split(':')[0]}\n" \
      "Port: #{normalized_lines.last[1].split(':')[1]}\n" \
      "Origin: #{normalized_lines.last[1].split(':')[0]}\n" \
      "Accept: #{normalized_lines[0][1]}" \
    "</pre>"
  end
  # ResponseHandler
  def check_path(normalized_lines)
    path = normalized_lines[1][1]
    if path == "/"
      "#{diagnostic_template(normalized_lines)}"
    elsif path == "/hello"
      @hello_count += 1
      "<p>Hello, World! (#{hello_count - 1})</p>"
    elsif path == "/clear_count"
      reset_count
    elsif path == "/datetime"
      datetime = Time.now.strftime("%I:%M%p on %A, %B %d, %Y")
      "<p>#{datetime}</p>"
    elsif path == "/shutdown"
      @close_server = true
      "<p>Total Requests: #{request_count}</p>"
    end
  end

  # Server
  def start_server
    loop do
      @client = tcp_server.accept
      parse_request
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
  server.start_server
end
