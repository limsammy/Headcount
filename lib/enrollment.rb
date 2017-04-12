class Enrollment
  attr_reader :name

  def initialize(args)
    @name = args[:name]
    args.delete(:name)
    @data = args
  end

  def kindergarten_participation_by_year
    @data[:kindergarten_participation]
  end

  def kindergarten_participation_in_year(year)
    @data[:kindergarten_participation][year]
  end

  def graduation_rate_by_year
    @data[:high_school_graduation]
  end

  def graduation_rate_in_year(year)
    @data[:high_school_graduation][year]
  end

  def update_data(args)
    args.delete(:name)
    args.each do |category, value|
      if @data[category].nil?
        @data[category] = value
      else
        @data[category].merge!(value)
      end
    end
  end
end
