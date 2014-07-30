class ParseLog
  attr_reader :length, :percent, :status, :http_code

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
          @status = :connecting
        end
      when /^Resolving/
        if line.match /\.\.\. failed/
          @status = :dns_error
          @header_parsed = true
        end
      when /^HTTP/
        if line.match /\.\.\.\s*(\d\d\d).*/
          @http_code = $1
          # FIXME
          unless @http_code == '302'
            @header_parsed = true
            if @http_code == '200'
              @status = :downloading
            else
              @status = :http_error
            end
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