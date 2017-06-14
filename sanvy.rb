#sanvy.rb
require 'json'


file = File.read('test.json')
resources = JSON.parse(file)

assertion_string=""
resource_string=""

resources.each do |data_hash|
  resource_string="it { is_expected.to contain_#{data_hash['type']}(\"#{data_hash['name']}\").with("
  data_hash.each do |key, value|
    next if ["name","type"].include? key
    assertion_string += "\"#{key}\" => \"#{value}\" ,\n"
  end
end
assertion_string += " )} "
puts resource_string
puts assertion_string
