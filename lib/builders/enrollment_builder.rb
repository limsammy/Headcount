require_relative '../csv_parser'
class EnrollmentBuilder
  include CSVParser

  def initialize(repository)
    @repository = repository
  end

  # def self.build_data(category, file)
  #   builder = EnrollmentBuilder.new
  #   builder.build_data(category, file)
  # end

  def build_data(category, file)
    contents = parse_file(file)
    process_data(contents, category)
  end

  def process_data(contents, category)
    data_category = translate_category(category)
    contents.map do |row|
      process_row(row, data_category)
    end
  end

  def process_row(row, data_category)
    sanitize(row)
    enrollment_data = make_enrollment_data(row, data_category)
    enrollment = @repository.find_by_name(row[:location])
    populate_data(row, enrollment_data, enrollment)
  end

  def create_enrollment(enrollment_data)
    @repository.data << Enrollment.new(enrollment_data)
  end

  private

  def sanitize(row)
    row[:location] = row[:location].upcase
    row[:data] = format_percent(row[:data]) if row[:dataformat] == "Percent"
  end

  def populate_data(row, enrollment_data, enrollment)
    if enrollment
      enrollment.update_data(enrollment_data)
    else
      create_enrollment(enrollment_data)
    end
    row[:location]
  end

  def translate_category(category)
    categories = {
      :kindergarten => :kindergarten_participation
    }
    categories[category] || category
  end

  def make_enrollment_data(row, data_category)
    { :name => row[:location],
      data_category => {row[:timeframe].to_i => row[:data]} }
  end
end
