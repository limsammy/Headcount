class Enrollment
  attr_reader :name

  def initialize(args)
    @name = args[:name]
    @repo = args[:repo]
    @data = {}
  end

  def kindergarten_participation_by_year
    @data[:kindergarten_participation]
  end

  def kindergarten_participation_in_year(year)
    @data[:kindergarten_participation][year]
  end
end
