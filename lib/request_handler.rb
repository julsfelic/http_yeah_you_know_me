module RequestHandler

  def normalized_request(parsed_request)
    keys = ["HTTP/1.1", "Host", "Accept:"]
    key_lines = parsed_request.select do |line|
      keys.any? do |key|
        line.include?(key)
      end
    end
    formatted_header = key_lines.map { |line| line.split(" ") }
    [formatted_header[1], formatted_header[0], formatted_header[2]]
  end

  def parsed_request
    client.recv(1024).split("\r\n")
  end

  def process_request
    normalized_request(parsed_request)
  end
end
