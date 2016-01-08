module RequestHandler

  def get_key_lines(parsed_request)
    keys = ["HTTP/1.1", "Host", "Accept:", "guess"]
    parsed_request.select do |line|
      keys.any? do |key|
        line.include?(key)
      end
    end
  end

  def normalized_request(parsed_request)
    key_lines = get_key_lines(parsed_request)
    formatted_header = key_lines.map { |line| line.split(" ") }
    formatted_header.sort_by!(&:count)
    if key_lines.last.include?("guess")
      [formatted_header[1], formatted_header[3],
       formatted_header[2], formatted_header[0]]
    else
      [formatted_header[0], formatted_header[2], formatted_header[1]]
    end
  end

  def parsed_request
    client.recv(1024).split("\r\n")
  end

  def process_request
    normalized_request(parsed_request)
  end
end
