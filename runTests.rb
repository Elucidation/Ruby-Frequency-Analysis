#!/usr/bin/env ruby
# File:  tc_simple_number.rb
require_relative "countWords"
require "minitest/autorun"

# Helper function to create and write a test file quickly
def createTempFile(filename, data)
  f = File.open(filename,'w')
    f.puts(data)
    f.close
end

class TestCountWords < Minitest::Unit::TestCase
 
  def test_simple
    filename = '/tmp/test_simple.txt'
    
    # Create and populate a temporary file
    createTempFile(filename, 'the test is the main test of testing with a test.')

    result = buildWordDictionary(filename)
    # Expected:
    # {"the"=>2, "test"=>3, "is"=>1, "main"=>1, "of"=>1, "testing"=>1, "with"=>1}
    assert_equal(7, result.length, "failure on check of length" )
    assert_equal(2, result["the"], "failure on check for 'the'" )
    assert_equal(3, result["test"], "failure on check for 'test'" )
    assert_equal(1, result["is"], "failure on check for 'is'" )
    assert_equal(1, result["main"], "failure on check for 'main'" )
    assert_equal(1, result["of"], "failure on check for 'of'" )
    assert_equal(1, result["testing"], "failure on check for 'testing'" )
    assert_equal(0, result["other"], "failure on check for nonexistance of 'other'" )
  end

  def test_null
    filename = '/tmp/test_null.txt'
    
    createTempFile(filename, '')
    result = buildWordDictionary(filename)
    # Expected:
    # {}
    assert_equal(0, result.length, "failure on check of length" )
    assert_equal(0, result["other"], "failure on check for nonexistance of 'other'" )
  end

  def test_repeat
    filename = '/tmp/test_repeat.txt'
    
    createTempFile(filename, 'apple apple apple apple apple apple apple apple apple apple apple apple')
    result = buildWordDictionary(filename)
    # Expected:
    # {}
    assert_equal(1, result.length, "failure on check of length" )
    assert_equal(12, result["apple"], "failure on check for 'apple'" )
    assert_equal(0, result["other"], "failure on check for nonexistance of 'other'" )
  end
 
end

