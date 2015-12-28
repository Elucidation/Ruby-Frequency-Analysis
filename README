# Ruby Frequency Analysis [![Build Status](https://travis-ci.org/Elucidation/Ruby-Frequency-Analysis.svg?branch=master)](https://travis-ci.org/Elucidation/Ruby-Frequency-Analysis)

The ruby script wordStats.rb is a command line script that takes input text files and returns some simple statistics on the data within. 
The purpose of this script is to be a simple test-case for a future rails web service version.

Usage: wordStats.rb [options] file1 file2...
    -v, --verbose                    Output more information
    -w, --word-length N              Minimum word length (Integer > 1)
    -o, --occurences N               Minimum number of occurences (Default: 2)
    -i, --interactive                Script pauses between each file
    -h, --help                       Display this screen

Example usage
./wordStats.rb *.txt -w 3 -o 10

## Unit Tests
`countWords.rb` contains a function that reads a filename and returns a Hash of all the words and the number of occurrences. runTests.rb uses this function for a few basic tests.
