require_relative 'district'
require_relative 'csv_query'
require_relative 'enrollment_repository'

class DistrictRepository
  attr_reader :enrollment_repo, :testing_repo, :econ_repo, :data

  def initialize
    @data = []
    @enrollment_repo = nil
    @testing_repo = nil
    @econ_repo = nil
  end

  def load_data(args)
    if args.key?[:enrollment]
      @enrollment_repo = EnrollmentRepository.new if @enrollment_repo.nil?
      district_data = @enrollment_repo.load_data({enrollment: args[:enrollment]})
      populate_data(district_data)
    end
    # populate @data keys with district names
    # create and populate _repo if needed
    # send appropriate data to repo
  end

  def populate_data(districts)
    districts.uniq.each do |district|
      find_by_name(district)
    end
  end

  def find_by_name(name)
    name = name.upcase unless name == "Colorado"
    create_district(name) if data[name].nil?
    data[name] ||= create_district(name)
  end

  def find_all_matching(text)
    found = data.select do |name, district|
      name.include? text.upcase
    end
    found.values
  end

  def create_district(name)
    data << District.new({name: name, repo: self})
  end
end
