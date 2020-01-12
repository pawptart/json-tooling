$payload = JSON.parse(File.read('payload.json'))

def reverse_keys_and_values
  $payload.keys.each_with_index do |key,i|
    row = "\"#{$payload[key]}\": \"#{key}\""
    row += ',' if i < $payload.keys.size - 1
    puts row
  end
end

reverse_keys_and_values