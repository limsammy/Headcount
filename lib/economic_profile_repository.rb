require 'pry'

class EconomicProfileRepository
  attr_reader :data

  def initialize
    @data = []
  end

  def load_data(args)
    added_districts = []
    args[:economic_profile].each do |category, file|
      builder = EconomicProfileBuilder.new(self)
      added_districts << builder.build_profile(file, category)
    end
    added_districts.flatten.compact.uniq
  end

  def find_by_name(name)
    data.find { |profile| profile.name == name }
  end

end
