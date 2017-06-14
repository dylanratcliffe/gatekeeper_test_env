#sanvy.rb
require 'json'

counter = 1
file = File.new("somefile.yaml", "r")
while (line = file.gets)
    puts "#{counter}: #{line}"
    counter = counter + 1
end
file.close

puts
puts
puts "End of normal read file"

file = File.read('data.json')
data_hash = JSON.parse(file)

data_hash.each do |key, data_hash|
  puts "#{key}-----"
  puts data_hash
end

puts
puts
puts "End of  read json"
