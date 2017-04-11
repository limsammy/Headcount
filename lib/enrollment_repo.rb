require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :data

  def initialize
    @data = {}
  end

  def load_data
    # populate @data keys with district names
    # parse appropriate data and create/store enrollment objects
  end

  def find_by_name(name)
    name = name.upcase
    create_enrollment(name) unless data.key?(name)
    data[name]
  end

  def create_enrollment(name)
    data[name] = Enrollment.new({name: name})
    # set district object on Enrollment?
  end
end
