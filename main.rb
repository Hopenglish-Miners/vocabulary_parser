require 'open-uri'
require 'pdf-reader'
require 'json'

io     = open('in/inputfile.pdf')
reader = PDF::Reader.new(io)
out = Hash.new

def invalid?(string)
  invalid = false
  if string =~ /\d/ or string.strip.empty? or (!string.scan(/\)/).empty? and string.scan(/\(/).empty?)
    valid = true
  end
  valid
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

#puts JSON.pretty_generate(out)
File.open("vocabulary.json","w") do |f|
  f.write(out.to_json)
end
