#!/usr/bin/env ruby

require './parse_log'

if ARGV.length < 1
  puts "Missing file as parameter"
  exit
end

filename = ARGV.first
p = ParseLog.new filename
p.check
puts "[#{filename}] code: #{p.http_code}, status: #{p.status}, length: #{p.length}, percent: #{p.percent}, seconds_remaining: #{p.seconds_remaining}"