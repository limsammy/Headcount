require_relative 'economic_profile'
require_relative 'csv_parser'
require 'pry'

class EconomicProfileRepository
  include CSVParser
  attr_reader :data

  def initialize
    @data = []
  end

  def load_data(args)
    added_districts = []
    args[:enrollment].each do |category, file|
      contents = parse_file(file)
      added_districts = added_districts + process_data(contents, category)
    end
    added_districts.uniq
  end

  def process_data(contents, category)
    
  end

  def create_economic_profile(economic_data)
  end

  def find_by_name(name)

  end

end
