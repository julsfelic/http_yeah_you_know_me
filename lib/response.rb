class Response
  attr_reader :verb, :path, :protocol, :host, :port, :origin, :accept

  def initialize
    @verb     = ""
    @path     = ""
    @protocol = ""
    @host     = ""
    @port     = ""
    @origin   = ""
    @accept   = ""
  end

  def process_lines(request_lines)
    @verb     = request_lines[1][0]
    @path     = request_lines[1][1]
    @protocol = request_lines[1][2]
    @host     = request_lines.last[1].split(':')[0]
    @origin   = host
    @port     = request_lines.last[1].split(':')[1]
    @accept   = request_lines[0][1]
    self
  end
end
