# Put raw JSON payload into payload.json
# Then just run the app!

$payload = JSON.parse(File.read('payload.json'))
$new_fields = {}

def map_fields(object = $payload)
  if object.is_a? Array
    object.each do |item|
      map_fields(item)
    end
  elsif object.is_a? Hash
    object.keys.each do |key|
      $new_fields[key] = convert(key)
      map_fields(object[key]) if object[key].is_a? Hash
    end
  end
end

def convert(key)
  key.to_s.split(/(?=[A-Z])/).map(&:downcase).join('_')
end

def print_values(hash)
  hash.keys.each_with_index do |key,i|
    row = "\"#{key}\": \"#{convert(key)}\""
    row += ',' if i < hash.keys.size - 1
    puts row
  end
end

map_fields
print_values($new_fields)