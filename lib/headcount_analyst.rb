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
    # data.each do |set, value|
      raise InsufficientInformationError, 'A grade must be provided to answer this question.' unless data.key?(:grade)
      raise UnknownDataError, "#{data[:grade]} is not a known grade." if data[:grade] != 3 && data[:grade] != 8
    # end
    # if data[:subject].nil?
    #   find_top_test_across_grade(data[:grade], data[:top])
    # else
    #   find_calcs_by_subject(data[:grade], data[:subject], data[:top])
    # end
  end

  def calculate_top_district_for_category(data)
    binding.pry
    data = @district_repository.testing_repo.find_by_category(data[:grade])
  end



  # def calculate_growth(grade, subject, top)
  #   binding.pry
  #   data = @district_repository.testing_repo.map do |item|
  #       item.data[grade]
  #       end
  #   result = data.map do |item|
  #       item.map do |item|
  #         {item[:year] => item[subject.to_s]}
  #       end
  #   end
  # end

  # def find_top_test_across_grade(grade, top)
  #   math = find_calcs_by_subject(grade, 'math', top)
  #   reading = find_calcs_by_subject(grade, 'reading', top)
  #   writing = find_calcs_by_subject(grade, 'writing', top)
  #   combine_subjects(math, reading, writing, grade)
  # end

  # def average(math, reading, writing, grade)
  #   names = @district_repository.testing_repo.name
  #   math = names.zip(math)
  #   reading = names.zip(reading)
  #   writing = names.zip(writing)
  #   combine_subjects(math, reading, writing, grade)
  # end

  # def combine_subjects(math, reading, writing)
  #   sum = math.reduce ({}) do |result, item|
  #     if result[item[0]].nil?
  #       result[item[0]] = item[1]
  #     else
  #       result[item] << item
  #     end
  #     result
  #   end

  #   writing.map do |item|
  #     if add_all[item[0]].nil?
  #       add_all.store(item[0], item[1])
  #     else
  #        add_all[item[0]] = [add_all[item[0]], item[1]]
  #      end
  #    end

  #   reading.map do |item|
  #      if add_all[item[0]].nil?
  #        add_all.store(item[0], item[1])
  #      else
  #         add_all[item[0]] = [add_all[item[0]], item[1]]
  #       end
  #     end

  #   averages = add_all.map do |item|
  #     x = item.flatten
  #     [x[0], x[1..-1].reduce(:+)/x.size - 1]
  #   end
  #   result_across_subjects(averages)
  # end

  # def result_across_subjects(averages)
  #   names = averages.map do |item|
  #     item[0]
  #   end
  #   values = averages.map do |item|
  #     item[1]
  #   end
  #   value = values.max
  #   index = values.find_index(value)
  #   names[index]
  #   [names[index], value]
  # end

  # def find_calcs_across_all_subjects(grade, math, reading, writing)
  #   math = calculate_growth(grade, 'math', top)
  #   reading = calculate_growth(grade, 'reading', top)
  #   writing = calculate_growth(grade, 'writing', top)
  #   combine_subjects(math, reading, writing, grade)
  # end

  # def find_calcs_by_subject(grade, subject, top)
  #   average = calculate_growth(grade, subject, top)
  #   find_single(average, top)
  # end

  # def find_single(average, top)
  #   if top.nil?
  #     no_nil = eliminate_nil(average)
  #     value = no_nil.max
  #     index = average.find_index(value)
  #     name = @district_repository.testing_repo
  #     [name, value]
  #   else
  #     find_multiple(average, top)
  #   end
  # end

  # def find_multiple(average, top)
  #   name = @district_repository.testing_repo
  #   no_nil = eliminate_nil(average)
  #   values = no_nil.sort_by do |element|
  #     element * -1
  #   end
  #   result = values[0..(top - 1)].map do |item|
  #     [name[average.find_index(item)], item]
  #   end
  # end

  # def eliminate_nil(average)
  #   average.reject do |item|
  #       item.nil? || item.is_a?(Fixnum)
  #   end
  # end
end
