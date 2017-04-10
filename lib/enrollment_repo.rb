require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :data

  def initialize
    @data = {}
  end

  def load_data
  end

  def find_by_name(name)
    name = name.upcase
    create_district(name) unless data.key?(name)
    data[name]
  end

  def find_all_matching(text)
    found = data.select do |name, district|
      name.include? text.upcase
    end
    found.values
  end

  def create_enrollment(name)
    data[name] = Enrollment.new({name: name})
    # set district object on Enrollment?
  end
end
