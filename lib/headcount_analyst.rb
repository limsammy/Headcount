require_relative 'custom_errors'
require 'pry'

class HeadcountAnalyst

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_correlates_with_high_school_graduation(args)
    if args.key?(:across)
      districts = args[:across].map {|name| find_district(name)}
      correlation_count = count_all_correlations(districts)
      has_correlation([correlation_count, districts.length])
    elsif args[:for] == "STATEWIDE"
      correlation_count = count_all_correlations
      length_without_CO = (@district_repository.data.length - 1.0)
      has_correlation([correlation_count, length_without_CO])
    else
      variation = kindergarten_participation_against_high_school_graduation(args[:for])
      variation > 0.6 && variation < 1.5
    end
  end

  def count_all_correlations(set = @district_repository.data)
    set.count do |district|
      next if district.name == "COLORADO"
      args = {for: district.name}
      kindergarten_participation_correlates_with_high_school_graduation(args)
    end
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kindergarten_variation = kindergarten_participation_rate_variation(district, :against => 'COLORADO')
    district, statewide = districts_to_compare(district, 'COLORADO')
    district_years = district_high_school_by_year(district)
    statewide_years = district_high_school_by_year(statewide)
    high_school_variation = get_rate_variation([district_years, statewide_years])
    find_variation([kindergarten_variation, high_school_variation])
  end

  def kindergarten_participation_rate_variation(district, compare)
    this_district, other_district = districts_to_compare(district, compare[:against])
    this_years = district_kindergarten_by_year(this_district)
    other_years = district_kindergarten_by_year(other_district)
    get_rate_variation([this_years, other_years])
  end

  def kindergarten_participation_rate_variation_trend(district, compare)
    this_district, other_district = districts_to_compare(district, compare[:against])
    this_district_years = district_kindergarten_by_year(this_district)
    other_district_years = district_kindergarten_by_year(other_district)
    calculate_trend(this_district_years, other_district_years).sort.to_h
  end

  def get_rate_variation(years)
    this_average = find_average_years_for_district(years[0])
    other_average = find_average_years_for_district(years[1])
    find_variation([this_average, other_average])
  end

  def find_average_years_for_district(years)
    years = years.reject{|year, value| value == "N/A"}
    our_sum = years.values.inject(0) do |sum, value|
      sum + value
    end
    return 0 if years.length == 0
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

  def find_district(district_name)
    @district_repository.find_by_name(district_name)
  end

  def has_correlation(values)
    values[0] / values[1] > 0.7
  end

  def find_variation(values)
    (values[0] / values[1]).round(3)
  end

  def calculate_trend(years_1, years_2)
    years_1.merge(years_2) do |key, val_1, val_2|
      find_variation([val_1, val_2])
    end
  end

  def top_statewide_test_year_over_year_growth(data)
    raise InsufficientInformationError, 'A grade must be provided to answer this question.' unless data.key?(:grade)
    raise UnknownDataError, "#{data[:grade]} is not a known grade." if data[:grade] != 3 && data[:grade] != 8
    growths = get_districts_and_growths(data[:grade], [data[:subject]])
    if !data.key?(:top)
      find_single_top_district_growth(growths)
    elsif data.key?(:top)
      find_multiple_top_district_growths(growths, data[:top])
    end
  end

  def get_districts_and_growths(grade, subjects)
    subjects = [:math, :reading, :writing] if subjects.compact.empty?
    @district_repository.testing_repo.data.map do |test_object|
      # find districts growth in each subject
      # test_object.growth_by_grade_over_years(grade, subject)
      # get each subjects growth, then add and average by subjects.length
      sum = subjects.reduce(0) do |sum, subject|
        sum + test_object.growth_by_grade_over_years(grade, subject)
      end
      average = sum / subjects.length
      {:name => test_object.name, :growth => average}
    end
  end

  def find_single_top_district_growth(collection)
    top = collection.max_by{|x| x[:growth]}
    final = []
    final << top[:name]
    final << top[:growth]
    return final
  end

  def find_multiple_top_district_growths(collection, top)
    final = []
    # binding.pry
    sorted = collection.delete_if {|k| k[:growth] == 0.0}
    sorted = collection.sort_by {|k| k[:growth]}.reverse
    top.times do |i|
      final << [sorted[i][:name], sorted[i][:growth]]
    end
    # binding.pry
    final
  end
end
