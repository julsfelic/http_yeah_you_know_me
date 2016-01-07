module RequestHandler

  def normalized_lines(parsed_lines)
    keys = ["HTTP/1.1", "Host", "Accept:"]
    formatted_lines = parsed_lines.select do |line|
      keys.any? do |key|
        line.include?(key)
      end
    end
    formatted_lines.map { |line| line.split(" ") }.sort
  end

  def parsed_request
    client.recv(1024).split("\r\n")
  end

  def process_request
    normalized_lines(parsed_request)
  end
end
