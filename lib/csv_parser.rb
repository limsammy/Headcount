require 'csv'
require 'pry'

module CSVParser

  def parse_file(file_name)
    CSV.open file_name, headers:true, header_converters: :symbol
  end

  def format_percent(number)
    return "N/A" if number == "N/A"
    number.to_f.round(3)
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
