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
    contents.map do |row|
      process_row(row, category)
    end
  end

  def process_row(row, category)
    sanitize(row, category)
    if category == :free_or_reduced_price_lunch
      economic_data = make_economic_data_with_sub(row,category)
    else
      economic_data = make_economic_data(row,category)
    end
    populate_data(row, economic_data)
  end

  def make_economic_data(row, category)
    { :name => row[:location],
      data_category => {
        row[:timeframe].to_i => {
          row[sub_category].to_sym => row[:data]
        }
      }
    }
  end

  def make_economic_data_with_sub(row, category)
    { :name => row[:location],
      data_category => {
        row[:timeframe].to_i => {
          row[:dataformat].to_sym => row[:data]
        }
      }
    }
  end

  def translate_sub_category(category)
    sub_categories = {
      :third_grade  => :score,
      :eighth_grade => :score,
      :math         => :race_ethnicity,
      :reading      => :race_ethnicity,
      :writing      => :race_ethnicity,
      :
    }
    sub_categories[category]
  end

  def create_economic_profile(economic_data)
  end

  def find_by_name(name)

  end

end
