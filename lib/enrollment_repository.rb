require_relative 'enrollment'
require_relative 'csv_query'

class EnrollmentRepository
  include CSVQuery
  attr_reader :data

  def initialize
    @data = []
  end

  def load_data(args)
    args[:enrollment].each do |category, file|
      contents = parse_file(file)
      process_data(contents, category)
    end
    # populate @data keys with district names
    # parse appropriate data and create/store enrollment objects
  end

  def translate_category(category)
    categories = {
      kindergarten: :kindergarten_participation,
    }
    categories[category]
  end

  def process_data(contents, category)
    data_category = translate_category(category)
    contents.each do |row|
      if row[:dataformat] == "Percent"
        row[:data] = format_percent(row[:data])
      end
      enrollment_data = {
        :name => row[:location],
        data_category => {row[:timeframe] => row[:data]}
      }
      if find_by_name(row[:location])
        # append current data to enrollment object
        enrollment = find_by_name(row[:location])
        enrollment.update_data(enrollment_data)
      else
        create_enrollment(enrollment_data)
      end
      # create enrollment object for each location
      # - check @data if EO already exists.  If it does append new data to category
      # - if not there, create it
    end
  end

  def find_by_name(name)
    data.find { |enrollment| enrollment.name == name }
  end

  def create_enrollment(enrollment_data)
    data << Enrollment.new(enrollment_data)
  end
end
