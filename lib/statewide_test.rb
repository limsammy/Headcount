require_relative 'custom_errors'

class StatewideTest
  attr_reader :name, :data

  def initialize(args)
    @name = args[:name]
    args.delete(:name)
    @data = args
  end

  def validate_args(args)
    valid = {
      :grade => [3,8],
      :race => [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white],
      :subject => [:math, :reading, :writing],
      :year => [*(2008..2014)],
      :csap_year => [*(2011..2014)],
      :categories => [3, 8, :math, :reading, :writing]
    }
    args.each do |set, value|
      raise UnknownDataError unless valid[set].include?(value)
    end
  end

  def proficient_by_grade(grade)
    validate_args({grade:grade})
    return @data[:third_grade] if grade == 3
    return @data[:eighth_grade] if grade == 8
  end

  def find_by_category(grade, subject = nil)
    validate_args({categories:grade})
    # binding.pry
    if grade == 3
      if subject.nil?
        return @data[:third_grade]
      else
        # binding.pry
        return get_category_by_years_test(:third_grade, subject)
      end
    elsif grade == 8
      if subject.nil?
        return @data[:eighth_grade]
      else
        return get_category_by_years_test(:eighth_grade, subject)
      end
    end
  end

  def get_category_by_years_test(category, subject)
    formatted = {}
    @data[category].each do |year, test_result|
      formatted[year] =  test_result[subject]
    end
    formatted
  end

  def growth_by_grade_over_years(grade, subject = nil)
    validate_args({grade:grade, subject:subject})
    max_year = find_by_category(grade, subject).keys.max
    min_year = find_by_category(grade, subject).keys.min
    max_val = find_by_category(grade, subject)[max_year]
    min_val = find_by_category(grade, subject)[min_year]
    # binding.pry
    (max_val - min_val) / (max_year - min_year)
  end

  # def format_years_output(output, grade)
  #   formatted = {}
  #   output.each do |data|
  #     formatted[grade] = data[output]
  #   end
  #   formatted
  # end

  def proficient_by_race_or_ethnicity(race)
    validate_args({race:race})
    years = get_years_data(race)
    format_to_year_data(years)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    validate_args({grade:grade, subject:subject, year:year})
    return @data[:third_grade][year][subject] if grade == 3
    return @data[:eighth_grade][year][subject] if grade == 8
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    validate_args({subject:subject, race:race, csap_year:year})
    race_data = proficient_by_race_or_ethnicity(race)
    race_data[year][subject]
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
