#!/usr/bin/env ruby
# Takes in a string message
# Returns some statistics on letters and/or words used

require 'optparse'

## OPTIONS
options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: wordStats.rb [options] file1 file2..."
  
  options[:verbose] = false
  opts.on( '-v', '--verbose', 'Output more information' ) do
    options[:verbose] = true
  end

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
optparse.parse!
## END OPTIONS

if ARGV.length == 0
  puts optparse.banner
  exit
end
ARGV.each do |filename|
  numLines = 0
  begin
    f = File.open(filename,'r')
    puts "Performing letter/word statistics on file '#{filename}'"
    puts "Number of characters per line: " if options[:verbose]
    while line = f.gets
      if options[:verbose]
        puts "#{line.length} : #{line}"
      else
        print "#{line.length} "
      end
      numLines += 1
    end
    f.close
    puts
    puts "Number of lines: #{numLines}"
    puts "Finished reading file '#{filename}'\n\n"
  rescue => err
    puts "#{err}, Skipping..."
  end
end
