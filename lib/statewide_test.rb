require_relative 'custom_errors'

class StatewideTest
  attr_reader :name, :data

  def initialize(args)
    @name = args[:name]
    args.delete(:name)
    @data = args
  end

  def proficient_by_grade(grade)
    raise UnknownDataError unless [3,8].include?(grade)
    # can we use group_by here
    return @data[:third_grade] if grade == 3
    return @data[:eighth_grade] if grade == 8
  end

  def proficient_by_race_or_ethnicity(race)
    allowed = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
    raise UnknownDataError unless allowed.include?(race)
  end

  def update_data(args, look_in = @data)
    args.delete(:name) if args.key?(:name)
    args.each do |category, value|
      if look_in[category].nil?
        look_in[category] = value
      else
        update_data(value, look_in[category])
      end
    end
  end
end
