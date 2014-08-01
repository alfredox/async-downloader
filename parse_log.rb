class ParseLog
  attr_reader :length, :percent, :status, :http_code, :seconds_remaining

  def initialize(filename)
    @filename = filename
    @header_parsed = false
  end

  def check
    if @header_parsed
      parse_body if @status == :downloading
    else
      parse_header
      parse_body if @status == :downloading
    end
  end

  private

  def parse_body
    open(@filename) do |file|
      file.seek -300, IO::SEEK_END
      data = file.read
      # scans for the percent and time (for time, it's this format 1d3h4m0s)
      matches = data.scan /(\d+)% .* (\d+d)?(\d+h)?(\d+m)?(\d+s)/
      if (last_match = matches.last)
        @percent = last_match[0].to_i
        @seconds_remaining = last_match[1].to_i * 24 * 3600 + last_match[2].to_i * 3600 + last_match[3].to_i * 60 + last_match[4].to_i
      end
      if (finished_match = data.match /saved \[(\d+)\/(\d+)\]/)
        @percent = 100
        @seconds_remaining = 0
        # NOTE prehaps compare the final length with the original
      end
    end
  end

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
          @length = $1.to_i
        end
      end
    end
  end
end