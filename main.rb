require 'open-uri'
require 'pdf-reader'

io     = open('in/inputfile.pdf')
reader = PDF::Reader.new(io)
puts reader.info
