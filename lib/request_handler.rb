module RequestHandler

  def parse_request
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    format_response(normalized_lines(request_lines))
  end

end
