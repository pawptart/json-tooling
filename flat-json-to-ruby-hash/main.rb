# Put raw JSON payload into payload.json
# Then just run the app!

$payload = JSON.parse(File.read('payload.json'))

def print_values(hash)
  hash.keys.each_with_index do |key,i|
    row = "#{key}: #{convert_value(hash[key])}"
    row += ',' if i < hash.keys.size - 1
    puts row
  end
end

def convert_value(value)
  return value if !value.is_a?(String)

  "\"#{value}\""
end

print_values($payload)