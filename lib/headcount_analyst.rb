class HeadcountAnalyst

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district, compare)
    this_district = @district_repository.find_by_name(district)

    other_district = @district_repository.find_by_name(compare[:against])
    this_average = find_average_years_for_district(this_district)
    other_average = find_average_years_for_district(other_district)
    enforce_percentage( this_average / other_average )
  end

  def find_average_years_for_district(district)
    years = district.enrollment.kindergarten_participation_by_year
    our_sum = years.values.inject(0) do |sum, value|
      sum + value
    end
    our_sum / years.length
  end

  def enforce_percentage(value)
    value.round(3)
  end
end
