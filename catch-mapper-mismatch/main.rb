# This tool catches mismatches between existing mapping documents and
# added mappers.
#
# Returns duplicate keys with different values. Duplicate keys with 
# same values are able to be merged automatically and can be ignored.
#
# If duplicate keys can be merged, this script will do so automatically,
# sorting by input field name and outputting result.
#
# Otherwise, a list of ambiguous field names will be output.

class PayloadHelper
  attr_reader :payload, :fields

  def initialize(payload)
    @payload = payload
    @fields = strip_formatting.build_hash
  end

  def message
    success = "All fields have unique outputs, no correction needed."
    failure = "The following fields are not unique:"
    puts success, '' if unique_output?
    puts failure, ''
    discrepancies
  end

  def display_fields
    @fields.each do |key, val|
      puts "#{key.inspect}: #{val.inspect}"
    end
  end

  def unique_output?
    bool = @fields.keys.map do |key|
      @fields[key].uniq.size == 1
    end
    bool.all?(true)
  end

  def discrepancies
    discrepancies = []
    @fields.keys.map do |key|
      next unless @fields[key].uniq.size != 1
      discrepancies << "#{key.inspect}: #{@fields[key].inspect}"
    end
    discrepancies.each { |d| puts d }
  end

  def strip_braces
    @payload.gsub! /(\{|\})/, ''
    self
  end

  def strip_whitespace
    @payload.gsub! /\s/, ''
    self
  end

  def strip_quotes
    @payload.gsub! /\"/, ''
    self
  end

  def strip_formatting
    strip_braces
    strip_whitespace
    strip_quotes
    self
  end

  def build_hash
    hash = {}
    @payload.split("\,").map do |line|
      key, val = line.split(':')
      if hash[key].nil?
        hash[key] = [val]
      else
        hash[key] << val
      end
    end
    hash
  end

  def strip_duplicates
    return unless unique_output?
    puts "{"
    @fields.keys.sort.each_with_index do |key, i|
      row = "  #{key.inspect}: #{@fields[key].first.inspect}"
      row += ',' if i < @fields.keys.size - 1
      puts row
    end
    puts "}"
  end
end

def print_stars
  puts ''
  msg = " Attempting to strip duplicates... "
  star_size = (64 - msg.size) / 2
  extra_star = star_size * 2 + msg.size == 64 ? '' : '*'
  5.times do |i|
    if i == 2 
      puts '*' * star_size + msg + '*' * star_size + extra_star
    else 
      puts '*' * 64
    end
  end
  puts ''
end 

payload = File.read('payload.rb')
ph = PayloadHelper.new(payload)
ph.message
return if ph.unique_output?
print_stars
ph.strip_duplicates