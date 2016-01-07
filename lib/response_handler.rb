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
    # get word?????
    word = path.split("=").last
    # dictionary method
    dictionary = File.read("/usr/share/dict/words").split("\n")
    # maybe have getting the word together with finding word
    # find word method?, get rid of found and return value
    found = dictionary.any? { |dict_word| word == dict_word }
    if found
      "<p>#{word} is a known word</p>"
    else
      "<p>#{word} is not a known word</p>"
    end
  end

  def check_path(response)
    # get path string
    # remove backslash
    # convert to a sym
    # just call send with sym
    # break out into small methods named after the path
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
    elsif response.path == "/start_game"
      "<p>Good luck!</p>"
    elsif response.path == "/game"
      "<p>0 guesses taken</p>"
    elsif response.path == "/clear_count"
      reset_count
    elsif response.path == "/shutdown"
      @close_server = true
      "<p>Total Requests: #{request_count}</p>"
    end
  end

  def format_response(formatted_lines)
    response = Response.new
    response.process_lines(formatted_lines)
  end

  def process_response(request)
    # should probably be named response
    formatted_response = format_response(request)
    # maybe flip names
    response = check_path(formatted_response)
    output  = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    send_response(output: output, headers: headers)
  end
end
