require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :data

  def initialize
    @data = {}
  end

  def load_data(args)
    args[:enrollment].each do |file|

    end
    # populate @data keys with district names
    # parse appropriate data and create/store enrollment objects
  end

  def find_by_name(name)
    name = name.upcase
    create_enrollment(name) unless data.key?(name)
    data[name]
  end

  def create_enrollment(name, enrollment_data)
    data[name] = Enrollment.new({name: name, enrollment_data})
    # set district object on Enrollment?
  end
end
