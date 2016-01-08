class Response
  attr_accessor :status_code
  attr_reader :verb, :path, :protocol, :host, :port, :origin,
              :accept, :guess

  def initialize
    @verb        = ""
    @path        = ""
    @protocol    = ""
    @host        = ""
    @port        = ""
    @origin      = ""
    @accept      = ""
    @status_code = "200 ok"
    @guess       = nil
  end

  def process_lines(request_lines)
    @verb     = request_lines[1][0]
    @path     = request_lines[1][1]
    @protocol = request_lines[1][2]
    @host     = request_lines[2][1].split(':')[0]
    @origin   = host
    @port     = request_lines[2][1].split(':')[1]
    @accept   = request_lines[0][1]
    @guess    = request_lines.last[0].split("=").last.to_i
    self
  end

  def build_output(output_body)
    "<html><head></head><body>#{output_body}</body></html>"
  end

  def build_headers(output_length)
    headers = ["HTTP/1.1 #{status_code}",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{output_length}"]
    headers << "Location: HTTP://127.0.0.1:9292/game" if status_code == "302 Found"
    headers << "Connection: keep-alive"
    headers.join("\r\n") + "\r\n\r\n"
  end
end
