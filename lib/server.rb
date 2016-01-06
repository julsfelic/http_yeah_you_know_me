require "pry"
require "socket"

class Server
  attr_reader :tcp_server, :client, :count

  def initialize
    @tcp_server = TCPServer.new(9292)
    @client = nil
    @count = 0
  end

  def send_response(headers, output)
    client.puts headers
    client.puts output
    client.close
    @count += 1
  end

  def reset_count
    @count = -1
  end

  def format_response(request_lines)
    response = "#{diagnostic_template(request_lines)}"

    reset_count if request_lines[0].include? "/clear_count"

    # response = "<p>Hello, World! (#{count})</p>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    send_response(headers, output)
  end

  def diagnostic_template(request_lines)
    formatted_lines = request_lines.map { |e| e.split(" ") }.sort
    "<pre>" +
    "Verb: #{formatted_lines[1][0]}\n" +
    "Path: #{formatted_lines[1][1]}\n" +
    "Protocol: #{formatted_lines[1][2]}\n" +
    "Host: #{formatted_lines.last[1].split(":")[0]}\n" +
    "Port: #{formatted_lines.last[1].split(":")[1]}\n" +
    "Origin: #{formatted_lines.last[1].split(":")[0]}\n" +
    "Accept: #{formatted_lines[0][1]}" +
    "</pre>"
  end

  def parse_request
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    keys = ["HTTP/1.1", "Host", "Accept:"]
    formatted_lines = request_lines.select do |e|
      keys.any? do |key|
        e.include?(key)
      end
    end
    format_response(formatted_lines)
  end

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
