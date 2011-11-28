#!/usr/bin/env ruby
# Takes in a string message
# Returns some statistics on letters and/or words used

require 'optparse'
require 'benchmark'

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
  numChars = 0
  words = Hash.new(0)
  begin
    timeElapsed = Benchmark.realtime do
    f = File.open(filename,'r')
      puts "Performing letter/word statistics on file '#{filename}'"
      puts "Number of characters per line: " if options[:verbose]
      while line = f.gets
        line.chomp! # Remove trailing endline character \n
        if options[:verbose]
          puts "#{line.length} : #{line}"
        else
          print "#{line.length} "
        end
        numLines += 1
        numChars += line.length
        if line.length > 0
          cleanLine = line.scan(/[A-Za-z](?:\w)+|(?:[A-Za-z]\.)+[A-Za-z]?/)
          puts "#{cleanLine.length} words :: #{cleanLine.join(' ')}" if options[:verbose]
          cleanLine.each do |word|
            words[word] += 1
          end
        end
        puts 
      end
      f.close
    end
    puts
    puts "Number of lines: #{numLines}, Number of characters: #{numChars}"
    words.reject! {|k,v| v <= 1}
    puts "Word count (2+ occurences, ignore single-letter words): #{words}"
    puts "Most frequent word: #{words.key(words.values.max)}"
    puts "Time elapsed: #{timeElapsed}s"
    puts "Finished reading file '#{filename}'\n\n"
  rescue => err
    puts "#{err}, Skipping..."
  end
end
