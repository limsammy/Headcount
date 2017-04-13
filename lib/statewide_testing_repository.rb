class StatewideTestRepository
  attr_reader :data

  def initialize
    @data = []
  end

  def load_data(args)
    added_districts = []
    args[:statewide_testing].each do |category, file|
      builder = StatewideTestBuilder.new(self)
      added_districts << builder.build_test(file, category)
    end
    added_districts.flatten.uniq
  end

  def find_by_name(name)
    data.find { |statewide_test| statewide_test.name == name }
  end
end
