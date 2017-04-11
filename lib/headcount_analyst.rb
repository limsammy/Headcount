require 'bigdecimal'
require 'bigdecimal/util'

class HeadcountAnalyst

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district, compare)
    this_district,other_district = districts_to_compare(district, compare[:against])
    this_average = find_average_years_for_district(this_district)
    other_average = find_average_years_for_district(other_district)
    enforce_percentage( this_average / other_average )
  end

  def find_average_years_for_district(district)
    years = district_kindergarten_by_year(district)
    our_sum = years.values.inject(0) do |sum, value|
      sum + value
    end
    our_sum / years.length
  end

  def district_kindergarten_by_year(district)
    district.enrollment.kindergarten_participation_by_year
  end

  def districts_to_compare(name_1, name_2)
    district_1 = @district_repository.find_by_name(name_1)
    district_2 = @district_repository.find_by_name(name_2)
    [district_1, district_2]
  end

  def enforce_percentage(value)
    value.round(3)
  end

  def kindergarten_participation_rate_variation_trend(district, compare)
    this_district,other_district = districts_to_compare(district, compare[:against])
    this_district_years = district_kindergarten_by_year(this_district)
    other_district_years = district_kindergarten_by_year(other_district)
    calculate_trend(this_district_years, other_district_years).sort.to_h
  end

  def calculate_trend(years_1, years_2)
    years_1.merge(years_2) do |key, val_1, val_2|
      enforce_percentage(val_1 / val_2)
    end
  end
end
