require 'open-uri'
require 'pdf-reader'
require 'json'

io     = open('in/inputfile.pdf')
reader = PDF::Reader.new(io)
out = Hash.new

def is_number? string
  true if Float(string) rescue false
end

reader.pages.each do |page|
  unless page.number == 1
    key = page.text.lines.first.strip
    out[key] = Array.new unless out.key?(key)
    page.text.delete('LEVEL 1 (1,080 words)').lines.each_with_index do |line,index|
      out[key].push(line.strip) unless line.strip.empty? && is_number?(line.strip)
    end
  end
end

File.open("vocabulary.json","w") do |f|
  f.write(out.to_json)
end
