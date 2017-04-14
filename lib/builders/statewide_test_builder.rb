require_relative '../csv_parser'
require_relative '../statewide_test'

class StatewideTestBuilder
  include CSVParser

  def initialize(repository)
    @repository = repository
  end

  def build_test(file, category)
    contents = parse_file(file)
    process_data(contents, category)
  end

  def process_data(contents, category)
    contents.map do |row|
      process_row(row, category)
    end
  end

  def process_row(row, category)
    sub_category = sub_categories[category]
    sanitize(row, sub_category)
    testing_data = make_testing_data(row, category, sub_category)
    populate_data(row, testing_data)
  end

  def create_statewide_test(statewide_test)
    @repository.data << StatewideTest.new(statewide_test)
  end

  private

  def sub_categories
    {
      :third_grade  => :score,
      :eighth_grade => :score,
      :math         => :race_ethnicity,
      :reading      => :race_ethnicity,
      :writing      => :race_ethnicity
    }
  end

  def sanitize(row, sub_category)
    row[:location] = row[:location].upcase
    row[sub_category] = row[sub_category].downcase.gsub(" ", "_")
    if row[:dataformat] == "Percent"
      row[:data] = format_percent(row[:data])
    end
    if row[sub_category] == "Hawaiian/Pacific Islander"
      row[sub_category] = "Pacific Islander"
    end
  end

  def populate_data(row, data)
    statewide_test = @repository.find_by_name(row[:location])
    if statewide_test
      statewide_test.update_data(data)
    else
      create_statewide_test(data)
    end
    row[:location]
  end

  def make_testing_data(row, category, sub_category)
    { :name => row[:location],
      category => {
        row[:timeframe].to_i => {
          row[sub_category].to_sym => row[:data]
        }
      }
    }
  end
end
