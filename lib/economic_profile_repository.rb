require_relative 'enrollment'
require_relative 'csv_parser'
require 'pry'

class EconomicProfileRepository
  include CSVParser
  attr_reader :data

  def initialize
    @data = []
  end

  def load_data(args)
  end

  def process_data
  end

  def create_economic_profile(economic_data)
  end

  def find_by_name(name)
    
  end

end
