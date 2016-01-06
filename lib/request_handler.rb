module RequestHandler

  def normalized_lines(request_lines)
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
    format_response(normalized_lines(request_lines))
  end
end
