#!/usr/bin/env ruby


require './parse_log'



p = ParseLog.new 'header_ok.log'
p.check
puts "[header_ok] code: #{p.http_code}, status: #{p.status}, length: #{p.length}"

p = ParseLog.new 'header_not_exist.log'
p.check
puts "[header_not_exist] code: #{p.http_code}, status: #{p.status}, length: #{p.length}"

p = ParseLog.new 'header_not_ip.log'
p.check
puts "[header_not_ip] code: #{p.http_code}, status: #{p.status}, length: #{p.length}"

p = ParseLog.new 'header_redirected.log'
p.check
puts "[header_redirected] code: #{p.http_code}, status: #{p.status}, length: #{p.length}"

p = ParseLog.new 'header_unresolved.log'
p.check
puts "[header_unresolved] code: #{p.http_code}, status: #{p.status}, length: #{p.length}"