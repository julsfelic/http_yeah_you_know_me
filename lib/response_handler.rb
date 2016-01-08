require 'response'
require 'game'

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

  def lookup_word(path)
    word = path.split("=").last
    dictionary = File.read("/usr/share/dict/words").split("\n")
    found = dictionary.any? { |dict_word| word == dict_word }
    if found
      "<p>#{word} is a known word</p>"
    else
      "<p>#{word} is not a known word</p>"
    end
  end

  def clear_count
    reset_count
  end

  def hello
    @hello_count += 1
    "<p>Hello, World! (#{hello_count - 1})</p>"
  end

  def datetime
    datetime = Time.now.strftime("%I:%M%p on %A, %B %d, %Y")
    "<p>#{datetime}</p>"
  end

  def word_search(response)
    lookup_word(response.path)
  end

  def start_game
    @game = Game.new
    "<p>Good luck!</p>"
  end

  def play_game(response)
    if response.verb == "GET"
      guess_msg = "<p>Guess count: #{game.guessed_count}</p>"
      check_result = game.guess_checker
      if check_result == -1
        guess_msg += "<p>Guess was too low!</p>"
      elsif check_result == 0
        guess_msg += "<p>You guessed correctly! (Game reset)</p>"
      elsif check_result == 1
        guess_msg += "<p>Guess was too high!</p>"
      else
        guess_msg
      end
    elsif response.verb == "POST"
      @game.guessed_num    = response.guess
      @game.guessed_count += 1
      response.status_code = "302 Found"
    end
  end

  def shutdown
    @close_server = true
    "<p>Total Requests: #{request_count}</p>"
  end

  def check_path(response)
    if response.path == "/"
      "#{diagnostic_template(response)}"
    elsif response.path.include?("word_search")
      word_search(response)
    else
      path = response.path.delete("/").to_sym
      path == :game ? play_game(response) : send(path)
    end
  end

  def format_response(formatted_lines)
    response = Response.new
    response.process_lines(formatted_lines)
  end

  def process_response(request)
    response = format_response(request)
    output_body = check_path(response)
    output = response.build_output(output_body)
    headers = response.build_headers(output.length)
    send_response(response, output: output, headers: headers)
  end
end
