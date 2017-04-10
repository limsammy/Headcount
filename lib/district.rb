class District
  attr_reader :name

  def initialize(args)
    @name = args[:name]
    @repo = args[:repo] || nil
  end

  def enrollment
    @repo.enrollment_repo(name)
  end
end
