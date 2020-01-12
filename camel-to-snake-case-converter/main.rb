$payload = JSON.parse(File.read('payload.json'))

def convert_keys_to_mapper(type:)
  $payload.keys.each_with_index do |key,i|
    row = "\"#{key}\": \"#{convert_key(key, to: type)}\""
    row += ',' if i < $payload.keys.size - 1
    puts row
  end
end

def convert_key(key, to:)
  if to == :response
    return 'Already converted!' if key.to_s.match?(/(^[a-z]|[A-Z0-9])[a-z]*/)
    key.to_s.split(/(?=[A-Z])/).map(&:downcase).join('_')
  elsif to == :request
    return 'Already converted!' if key.to_s.match?(/\_/)
    key.to_s.split('_').map(&:upcase).join.downcase
  end
end

def initiate_conversion
  puts "Convert to Request or Response? (request/response):"
  input = gets.chomp
  if !['request','response'].include? input
    puts "Please run again." 
    return
  end
  convert_keys_to_mapper(type: input.to_sym)
end

initiate_conversion