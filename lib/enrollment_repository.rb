require_relative './builders/enrollment_builder'
require 'pry'

class EnrollmentRepository
  attr_reader :data

  def initialize
    @data = []
  end

  def load_data(args)
    added_districts = []
    args[:enrollment].each do |category, file|
      builder = EnrollmentBuilder.new(self)
      added_districts << builder.build_enrollment(category, file)
    end
    added_districts.flatten.uniq
  end

  def find_by_name(name)
    data.find { |enrollment| enrollment.name == name }
  end
end
