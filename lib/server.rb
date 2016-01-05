require 'socket'
require 'pry'

class Server
  attr_reader :tcp_server, :count

  def initialize(port = 9292)
    @tcp_server = TCPServer.open(port)
    @count = 0
  end

  def send_response(client, args)
    client.puts args[:output]
    client.close
  end

  def build_response_message(client)
    response = "<p>Hello, World (#{count})</p>"
    output = "<html><head></head><body>#{response}</body></html>"
    send_response(client, output: output)
  end

  def build_request_message(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    build_response_message(client)
  end

  def accept
    loop do
      build_request_message(tcp_server.accept)
      @count += 1
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  server = Server.new(9292)
  server.accept
end
