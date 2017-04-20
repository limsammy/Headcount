require_relative 'custom_errors'
require_relative 'result_set'
require_relative 'result_entry'
require 'pry'

class HeadcountAnalyst
  attr_reader :district_repository

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_correlates_with_high_school_graduation(args)
    if args.key?(:across)
      districts = args[:across].map {|name| find_district(name)}
      correlation_count = count_all_correlations_k_to_hs(districts)
      has_correlation([correlation_count, districts.length])
    elsif args[:for] == "STATEWIDE"
      correlation_count = count_all_correlations_k_to_hs
      length_without_CO = (@district_repository.data.length - 1.0)
      has_correlation([correlation_count, length_without_CO])
    else
      v = kindergarten_participation_against_high_school_graduation(args[:for])
      v > 0.6 && v < 1.5
    end
  end

  def count_all_correlations_k_to_hs(set = @district_repository.data)
    set.count do |district|
      next if district.name == "COLORADO"
      args = {for: district.name}
      kindergarten_participation_correlates_with_high_school_graduation(args)
    end
  end

  def kindergarten_participation_against_high_school_graduation(d)
    k_v = kindergarten_participation_rate_variation(d, :against => 'COLORADO')
    d, statewide = districts_to_compare(d, 'COLORADO')
    district_years = district_high_school_by_year(d)
    statewide_years = district_high_school_by_year(statewide)
    hs_v = get_rate_variation([district_years, statewide_years])
    find_variation([k_v, hs_v])
  end

  def kindergarten_participation_rate_variation(district, compare)
    d, other_d = districts_to_compare(district, compare[:against])
    this_years = district_kindergarten_by_year(d)
    other_years = district_kindergarten_by_year(other_d)
    get_rate_variation([this_years, other_years])
  end

  def kindergarten_participation_rate_variation_trend(district, compare)
    d, other_d = districts_to_compare(district, compare[:against])
    d_years = district_kindergarten_by_year(d)
    other_d_years = district_kindergarten_by_year(other_d)
    calculate_trend(d_years, other_d_years).sort.to_h
  end

  def get_rate_variation(years)
    this_average = find_average_of_year_data(years[0])
    other_average = find_average_of_year_data(years[1])
    find_variation([this_average, other_average])
  end

  def find_average_of_year_data(years)
    years = years.reject{|year, value| value.is_a? String }
    return 0 if years.length == 0
    our_sum = years.values.reduce(0) do |sum, value|
      sum + value.to_f
    end
    our_sum / years.length
  end

  def district_kindergarten_by_year(district)
    district.enrollment.kindergarten_participation_by_year
  end

  def district_high_school_by_year(district)
    district.enrollment.graduation_rate_by_year
  end

  def districts_to_compare(name_1, name_2)
    district_1 = find_district(name_1)
    district_2 = find_district(name_2)
    [district_1, district_2]
  end

  def has_correlation(values)
    values[0] / values[1] > 0.7
  end

  def find_variation(values)
    values.map!(&:to_f)
    (values[0] / values[1]).round(3)
  end

  def calculate_trend(years_1, years_2)
    years_1.merge(years_2) do |key, val_1, val_2|
      find_variation([val_1, val_2])
    end
  end

  def validate_args(args)
    valid = {
      :grade => [3,8],
      :subject => [:math, :reading, :writing],
      :top => [*(1..181)]
    }
    message = 'A grade must be provided to answer this question.'
    raise InsufficientInformationError, message unless args.key?(:grade)
    args.each do |set, value|
      if set != :weighting
        is_valid = valid[set].include?(value)
      else
        is_valid = value.reduce(0) {|sum, (subject, weight)| sum + weight} == 1
      end
      raise UnknownDataError unless is_valid
    end
  end

  def top_statewide_test_year_over_year_growth(data)
    validate_args(data)
    grade = data[:grade]
    subject = [data[:subject]]
    weight = data[:weighting]
    growths = get_districts_and_growths(grade, subject, weight)
    if !data.key?(:top)
      find_single_top_district_growth(growths)
    elsif data.key?(:top)
      find_multiple_top_district_growths(growths, data[:top])
    end
  end

  def get_districts_and_growths(grade, subs, weight = nil)
    subs = [:math, :reading, :writing] if subs.compact.empty?
    @district_repository.testing_repo.data.map do |test_object|
      if !weight.nil?
        average = get_growth_weighted_average(test_object, grade, subs, weight)
      else
        average = get_growth_average(test_object, grade, subs)
      end
      {:name => test_object.name, :growth => average}
    end
  end

  def get_growth_weighted_average(test_object, grade, subjects, weight)
    subjects.reduce(0) do |sum, subject|
      growth = test_object.growth_by_grade_over_years(grade, subject)
      sum + (growth * weight[subject])
    end
  end

  def get_growth_average(test_object, grade, subjects)
    sum = subjects.reduce(0) do |sum, subject|
      sum + test_object.growth_by_grade_over_years(grade, subject)
    end
    sum / subjects.length
  end

  def find_single_top_district_growth(collection)
    top = collection.max_by{|x| x[:growth]}
    final = []
    final << top[:name]
    final << top[:growth].round(3)
    return final
  end

  def find_multiple_top_district_growths(collection, top)
    final = []
    sorted = collection.delete_if {|k| k[:growth] == 0.0}
    sorted = collection.sort_by {|k| k[:growth]}.reverse
    top.times do |i|
      final << [sorted[i][:name], sorted[i][:growth]]
    end
    final
  end

  def high_poverty_and_high_school_graduation
    districts = collect_district_result_entries
    state_data = {name: "COLORADO"}
    lunch = :free_and_reduced_price_lunch_rate
    state_data.merge!(state_average(districts, lunch))
    poverty = :children_in_poverty_rate
    state_data.merge!(state_average(districts, poverty))
    grad = :high_school_graduation_rate
    state_data.merge!(state_average(districts, grad))
    statewide = ResultEntry.new(state_data)
    keep_high_poverty_high_grad(districts, statewide)
    ResultSet.new(
      matching_districts: districts,
      statewide_average: statewide
    )
  end

  def high_income_disparity
    districts = collect_district_result_entries
    state_data = {name: "COLORADO"}
    state_data.merge!(state_average(districts, :children_in_poverty_rate))
    state_data.merge!(state_average(districts, :median_household_income))
    statewide = ResultEntry.new(state_data)
    keep_high_income_disparity(districts, statewide)
    ResultSet.new(
      matching_districts: districts,
      statewide_average: statewide
    )
  end

  def kindergarten_participation_against_household_income(name)
    compare = {:against => 'COLORADO'}
    k_v = kindergarten_participation_rate_variation(name, compare)
    income_variation = median_income_variation(name)
    (k_v / income_variation).round(3)
  end

  def median_income_variation(district)
    this_district, other_district = districts_to_compare(district, "COLORADO")
    this_average = district_median_income(this_district)
    other_average = district_median_income(other_district)
    find_variation([this_average, other_average])
  end

  def district_median_income(district)
    district.economic_profile.median_household_income_average.to_f
  end

  def kindergarten_participation_correlates_with_household_income(args)
    if args.key?(:across)
      districts = args[:across].map {|name| find_district(name)}
      correlation_count = count_all_correlations_k_to_income(districts)
      has_correlation([correlation_count, districts.length])
    elsif args[:for] == "STATEWIDE"
      correlation_count = count_all_correlations_k_to_income
      length_without_CO = (@district_repository.data.length - 1.0)
      has_correlation([correlation_count, length_without_CO])
    else
      v = kindergarten_participation_against_household_income(args[:for])
      v > 0.6 && v < 1.5
    end
  end

  def count_all_correlations_k_to_income(set = @district_repository.data)
    set.count do |district|
      next if district.name == "COLORADO"
      args = {for: district.name}
      kindergarten_participation_correlates_with_household_income(args)
    end
  end

  private

  def keep_high_income_disparity(ds, co)
    ds.keep_if do |d|
      higher_income?(d, co) && higher_poverty?(d, co)
    end
  end

  def keep_high_poverty_high_grad(ds, co)
    ds.keep_if do |d|
      higher_lunch?(d, co) && higher_poverty?(d, co) && higher_grad?(d, co)
    end
  end

  def higher_lunch?(d, co)
    d.free_and_reduced_price_lunch_rate > co.free_and_reduced_price_lunch_rate
  end

  def higher_poverty?(d, co)
    d.children_in_poverty_rate > co.children_in_poverty_rate
  end

  def higher_grad?(d, co)
    d.high_school_graduation_rate > co.high_school_graduation_rate
  end

  def higher_income?(d, co)
    d.median_household_income > co.median_household_income
  end

  def state_average(districts, category)
    sum = districts.reduce(0) do |sum, district|
      sum + district.send(category)
    end
    {category => (sum / districts.length).round(3)}
  end

  def average_lunch_students(economic_object)
    economic_object.average_number_of_lunch_students
  end

  def average_poverty_students(economic_object)
    data = economic_object.data[:children_in_poverty]
    find_average_of_year_data(data).round(3)
  end

  def average_median_income(economic_object)
    data = economic_object.data[:median_household_income]
    find_average_of_year_data(data).round(3)
  end

  def average_high_school_grad(enrollment_object)
    data = enrollment_object.data[:high_school_graduation]
    find_average_of_year_data(data).round(3)
  end

  def collect_district_result_entries
    @district_repository.data.map do |district|
      next if district.name == "COLORADO"
      economic = district.economic_profile
      enrollment = district.enrollment
      data = {
        name: district.name,
        free_and_reduced_price_lunch_rate: average_lunch_students(economic),
        children_in_poverty_rate: average_poverty_students(economic),
        high_school_graduation_rate: average_high_school_grad(enrollment),
        median_household_income: average_median_income(economic)
      }
      ResultEntry.new(data)
    end.compact
  end

  def find_district(district_name)
    @district_repository.find_by_name(district_name)
  end

  def find_economic_profile(name)
    @district_repository.economic_profile_repo.find_by_name(name)
  end

  def find_enrollment(name)
    @district_repository.enrollment_repo.find_by_name(name)
  end
end
