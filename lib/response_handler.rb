require 'response'

module ResponseHandler

  def diagnostic_template(response)
    "<pre>" \
      "Verb: #{response.verb}\n" \
      "Path: #{response.path}\n" \
      "Protocol: #{response.protocol}\n" \
      "Host: #{response.host}\n" \
      "Port: #{response.port}\n" \
      "Origin: #{response.origin}\n" \
      "Accept: #{response.accept}" \
    "</pre>"
  end

  def search_word(path)
    word = path.split("=").last
    dictionary = File.read("/usr/share/dict/words").split("\n")
    found = dictionary.any? { |dict_word| word == dict_word }
    if found
      "<p>#{word} is a known word</p>"
    else
      "<p>#{word} is not a known word</p>"
    end
  end

  def check_path(response)
    if response.path == "/"
      "#{diagnostic_template(response)}"
    elsif response.path == "/hello"
      @hello_count += 1
      "<p>Hello, World! (#{hello_count - 1})</p>"
    elsif response.path == "/datetime"
      datetime = Time.now.strftime("%I:%M%p on %A, %B %d, %Y")
      "<p>#{datetime}</p>"
    elsif response.path.include?("word_search")
      search_word(response.path)
    elsif response.path == "/clear_count"
      reset_count
    elsif response.path == "/shutdown"
      @close_server = true
      "<p>Total Requests: #{request_count}</p>"
    end
  end

  def format_response(normalized_lines)
    @request_count += 1
    response = Response.new
    response.process_lines(normalized_lines)
    response = check_path(response)
    output  = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    send_response(output: output, headers: headers)
  end

end
