def buildWordDictionary(filename)
  words = Hash.new(0)

  f = File.open(filename,'r')
  while line = f.gets
    line.chomp! # Remove trailing endline character \n
    if line.length > 0
      cleanLine = line.scan(/[A-Za-z](?:\w)+|(?:[A-Za-z]\.)+[A-Za-z]?/)
      cleanLine.each do |word|
        words[word] += 1
      end
    end
  end # line fgets
  f.close
  
  return words
end