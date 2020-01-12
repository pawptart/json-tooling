# frozen_string_literal: true

# Put raw JSON payload into payload.json
# Then just run the app!

require 'json'

$payload = JSON.parse(File.read('payload.json'))

def map_fields(object = $payload)
  if object.is_a? Array
    map_fields(object.first)
  elsif object.is_a? Hash
    object.keys.each do |key|
      value = object.delete(key)
      converted_key = convert(key)
      if value.is_a? Hash
        object[converted_key] = {
          type: :object,
          properties: value
        }
        map_fields(value)
      elsif value.is_a? Array
        object[converted_key] = {
          type: :array,
          items: [ value.first ]
        }
        map_fields(value)
      else
        object[converted_key] = parse_field(value)
      end
    end
  end
end

def convert(key)
  key.to_sym
end

def parse_field(value)
  type = value.nil? ? :string : value.class.to_s.downcase.to_sym
  {
    type: type,
    example: value,
    nullable: true
  }
end

def print_values(hash)
  JSON.pretty_generate(hash)
end

map_fields
print_values($payload)
