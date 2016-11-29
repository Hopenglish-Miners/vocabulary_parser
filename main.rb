require 'open-uri'
require 'pdf-reader'

io     = open('in/inputfile.pdf')
reader = PDF::Reader.new(io)

reader.pages.each do |page|
  puts "Page #{page.text.lines.first.strip}"
  page.text.lines.each do |line|
    puts line.strip.split(' ')
  end
end
