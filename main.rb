require 'open-uri'
require 'pdf-reader'
require 'json'

def invalid?(string)
  invalid = false
  #Check is is number
  if string =~ /\d/
    invalid = true
  end
  if string.strip.empty?
    invalid = true
  end
  #Check if the word has close parenthesis but not open
  # Example: word)
  if (!string.scan(/\)/).empty? and string.scan(/\(/).empty?)
    invalid = true
  end
  invalid
end

# Check if the word include parenthesis
def postfix?(string)
  !string.scan(/\(([^\)]+)\)/).empty?
end

# Check the parenthesis and create other word with postword
def create_more_words(string)
  # Get postfix
  post = string.scan(/\(([^\)]+)\)/).last.first
  word = string.sub(/\(([^\)]+)\)/,'')
  [word,word+post]
end

io     = open('in/inputfile.pdf')
reader = PDF::Reader.new(io)
out = Hash.new

# Read PDF and create hash with level and array of words
reader.pages.each do |page|
  unless page.number == 1
    key = page.text.lines.first.strip
    out[key] = Array.new unless out.key?(key)
    page.text.split(/[\s|\/]/).each_with_index do |line,index|
      line = line.strip
      unless invalid?(line)
        #Check if we can have to split the word in more.
        # example: tactic(s) -> [tactic,tactics]
        if postfix? line
          out[key].push(*create_more_words(line))
        else
          out[key].push(line)
        end
      end
    end
  end
end

# Order the words in every levels and add total information
out.each do |key, value|
  value.reject! {|c| c.empty?} #clean empty words
  out[key] = {"total" => value.size , "words" =>  value.sort}
end



# Save into file
File.open("vocabulary.json","w") do |f|
  f.write(out.to_json)
end
