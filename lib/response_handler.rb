module ResponseHandler

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
