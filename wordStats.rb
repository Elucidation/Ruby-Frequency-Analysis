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
  
  options[:minOccurences] = 2
  opts.on( '-o', '--occurences N', Integer, 'Minimum number of occurences (Default: 2)' ) do |o|
    options[:minOccurences] = o
  end
  
  options[:interactive] = false
  opts.on( '-i', '--interactive', 'Script pauses between each file' ) do |o|
    options[:interactive] = true
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

totalTime = Benchmark.realtime do

ARGV.each do |filename|
  numLines = 0
  numChars = 0
  words = Hash.new(0)
  wordDist = []
  begin
    timeElapsed = Benchmark.realtime do
      f = File.open(filename,'r')
      puts "--- #{filename}"
      puts "Performing letter/word statistics on file '#{filename}'" if options[:verbose]
      puts "Number of characters per line: "
      while line = f.gets
        line.chomp! # Remove trailing endline character \n
        if options[:verbose]
          puts "------------------------------------------------------"
          puts "ORIG #{line.length} chars: #{line}"
        else
          print "#{line.length} "
        end
        numLines += 1
        numChars += line.length
        if line.length > 0
          cleanLine = line.scan(/[A-Za-z](?:\w)+|(?:[A-Za-z]\.)+[A-Za-z]?/)
          cleanLine.reject! {|word| word.length < options[:minWordLength]} if options[:minWordLength]
          puts "CLEAN #{cleanLine.length} words :: #{cleanLine.join(' ')}" if options[:verbose]
          cleanLine.each do |word|
            words[word] += 1
          end
        end
      end # line fgets
      f.close
      # Word distribution culling
      words.reject! {|k,v| v < options[:minOccurences]} # remove single occurrences
      wordDist = words.to_a.sort{|x,y| y[1] <=> x[1]} # Sort big-small by occurrences
    end # Benchmark
    puts
    puts "Number of lines: #{numLines}, Number of characters: #{numChars}"
    puts "Word count (#{options[:minOccurences]}+ occurences, ignore single-letter words):"
    if options[:verbose]
      wordDist.each {|k,v| puts "#{k} : #{v}"}
    else
      puts wordDist[0..[10,wordDist.length-1].min].map {|k,v| "#{k} : #{v}"} .join(", ")
    end
    puts "Time elapsed: #{timeElapsed}s"
    (puts "\nPress ENTER to continue..."; $stdin.gets) if options[:interactive] 
  rescue => err
    puts "#{err}, Skipping..."
  end
end

end # totalTime Benchmark

puts "---"
puts "Finished : #{ARGV.length} Files processed in #{totalTime}s" if not options[:interactive] 
