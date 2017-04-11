require_relative 'district'

class DistrictRepository
  attr_reader :enrollment_repo, :testing_repo, :econ_repo, :data

  def initialize
    @data = {}
    @enrollment_repo = nil
    @testing_repo = nil
    @econ_repo = nil
  end

  def load_data(args)
    # populate @data keys with district names
    # create and populate _repo if needed
    # send appropriate data to repo
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

  def create_district(name)
    data[name] = District.new({name: name, repo: self})
  end
end
