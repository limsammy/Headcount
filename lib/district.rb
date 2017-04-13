class District
  attr_reader :name

  def initialize(args)
    @name = args[:name]
    @repo = args[:repo]
  end

  def enrollment
    @repo.enrollment_repo.find_by_name(name)
  end

  def statewide_test
    @repo.testing_repo.find_by_name(name)
  end

  def economic_profile
    @repo.economic_profile_repo.find_by_name(name)
  end
end
