class ParseLog
  attr_reader :length, :percent, :error, :http_code

  def initialize(filename)
    @filename = filename
    @header_parsed = false
  end

  def check
    if @header_parsed
    else
      parse_header
    end
  end

  private

  # this parses the different responses of wget
  # More for not connecting to IP, forbidden status, etc.
  def parse_header
    # should open the file
    IO.foreach(@filename) do |line|
      case line
      when /^Connecting/
        if line.match /\.\.\. failed/
          @error = :connection
        end
      when /^Resolving/
        if line.match /\.\.\. failed/
          @error = :dns
          @header_parsed = true
        end
      when /^HTTP/
        if line.match /\.\.\.\s*(\d\d\d).*/
          @http_code = $1
          # FIXME
          unless @http_code == '302'
            @header_parsed = true
            @error = :http unless @http_code == '200'
          end
        end
      when /^Length/
        if line.match /Length:\s*(\d*)/
          @length = $1
        end
      end
    end
  end
end