require 'socket'
require 'pry'

class Server
  attr_reader :tcp_server

  def initialize(port = 9292)
    @tcp_server = TCPServer.new(port)
    @count = 0
  end

  def send_response(client, args)
      client.puts args[:output]

    # if var == quit
    # client.close
    # else
    # accept
    # end
  end

  def build_response_message(client)
    response = "<p>Hello, World (0)</p>"
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
    build_request_message(tcp_server.accept)
  end

end

if __FILE__ == $PROGRAM_NAME
  server = Server.new(9292)
  server.accept
end
