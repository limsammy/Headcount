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
    return @data[:third_grade] if grade == 3
    return @data[:eighth_grade] if grade == 8
  end

  def proficient_by_race_or_ethnicity(race)
    allowed = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
    raise UnknownDataError unless allowed.include?(race)
    years = get_years_data(race)
    format_to_year_data(years)
  end

  def get_years_data(filter)
    tests = [:math, :reading, :writing]
    tests.map do |subject|
      get_category_by_years(filter, subject)
    end
  end

  def format_to_year_data(years)
    years = years.reduce(&:+)
    groups_deepened = group_into_years(years)
    flatten_groups(groups_deepened)
  end

  def flatten_groups(groups)
    sets = groups.map do |key, value|
      {key => value.reduce({}) {|h,pairs| pairs.each {|k,v| h[k] = v }; h }}
    end
    reduce_sets(sets)
  end

  def reduce_sets(sets)
    sets.reduce({}) do |h, sets|
      h.merge(sets)
    end
  end

  def group_into_years(years)
    year_groups = years.group_by do |year_subject|
      year_subject.keys.first
    end
    remove_year_keys(year_groups)
  end

  def remove_year_keys(year_groups)
    year_groups.map { |key, v| [key, v.map(&:values).flatten] }.to_h
  end

  def get_category_by_years(criteria, category)
    @data[category].map do |year, breakdown|
      {year => {category => breakdown[criteria]}}
    end
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
