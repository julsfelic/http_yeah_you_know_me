module ResponseHandler

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

  def format_response(normalized_lines)
    @request_count += 1
    response = check_path(normalized_lines)
    output  = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    send_response(output: output, headers: headers)
  end

end
