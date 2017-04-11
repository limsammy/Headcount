require 'csv'
require 'pry'

module CSVParser

  def parse_file(file_name)
    CSV.open file_name, headers:true, header_converters: :symbol
    # sanitize(contents)
    # find_records(contents, query)
  end

  def sanitize(contents)
    contents.each do |row|
      if row[:dataformat] == "Percent"
        row[:data] = format_percent(row[:data])
      end
      if row[:location] != "Colorado"
        row[:location] = row[:location].upcase
      end
    end
  end

  def format_percent(number)
    number.to_f.round(3)
  end

  ### Working but not used for now ###
  def csv_to_hash(contents)
    contents.to_a.map {|row| row.to_hash } #returns array of hashes, each hash storing data relevant to the district
  end

  def find_records(contents,query)
    search_in = query[:search_in].to_sym
    search_for = query[:find]
    result = contents.select do |row|
      row[search_in] == search_for
    end
    result
  end
end

# def get_column(contents, header)
#   contents.map do |row|
#     row[header]
#   end
# end
