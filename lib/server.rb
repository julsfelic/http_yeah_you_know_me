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
  end

  def reset_count
    @count = 0
  end

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

  def format_response(normalized_lines)
    response = ""
    path = normalized_lines[1][1]
    # think of using a hash instead of an if statement?
    if path == "/"
      response = "#{diagnostic_template(normalized_lines)}"
    elsif path == "/hello"
      response = "<p>Hello, World! (#{count})</p>"
      @count += 1
    elsif path == "/clear_count"
      reset_count
    end

    # response = ???
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    send_response(headers, output)
  end

  def normalize_request(request_lines)
    keys = ["HTTP/1.1", "Host", "Accept:"]
    formatted_lines = request_lines.select do |line|
      keys.any? do |key|
        line.include?(key)
      end
    end
    formatted_lines.map { |line| line.split(" ") }.sort
  end

  def parse_request
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    normalized_lines = normalize_request(request_lines)
    format_response(normalized_lines)
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
