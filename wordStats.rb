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
  
  options[:minWordLength] = nil
  opts.on( '-w', '--word-length N', Integer, 'Minimum word length (Integer > 1)' ) do |w|
    options[:minWordLength] = w
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
  wordDist = []
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
      end # line fgets
      f.close
      # Word distribution
      words.reject! {|k,v| v <= 1} # remove single occurrences
      words.reject! {|k,v| k.length <= options[:minWordLength]} if options[:minWordLength]
      wordDist = words.to_a.sort{|x,y| y[1] <=> x[1]} # Sort big-small by occurrences
    end # Benchmark
    puts
    puts "Number of lines: #{numLines}, Number of characters: #{numChars}"
    puts "Word count (2+ occurences, ignore single-letter words):"
    if wordDist.length < 10 or options[:verbose]
      wordDist.each {|k,v| puts "#{k} : #{v}"}
    else
      wordDist[0..10].each {|k,v| print "#{k} : #{v}, "}
      puts
    end
    puts "Time elapsed: #{timeElapsed}s"
    puts "Finished reading file '#{filename}'\n\n"
  rescue => err
    puts "#{err}, Skipping..."
  end
end
