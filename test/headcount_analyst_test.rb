require_relative 'test_helper'

class HeadcountAnalystTest < MiniTest::Test

  def setup
    @dr = DistrictRepository.new
    @dr_args = {:enrollment => {
      :kindergarten           => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"
    }}
    @dr.load_data(@dr_args)
    @ha = HeadcountAnalyst.new(@dr)

    # @swt = StatewideTestRepository.new
    @statewide_testing_args = {
      :statewide_testing => {
        :third_grade  => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math         => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
    @dr.load_data(@statewide_testing_args)
    @ha_test = HeadcountAnalyst.new(@dr)
  end

  def test_headcount_analyst_exists
    assert_instance_of HeadcountAnalyst, @ha
  end

  def test_headcount_analyst_responds_to_kindergarten_participation_rate_variation
    assert_respond_to(@ha, :kindergarten_participation_rate_variation)
  end

  def test_headcount_analyst_responds_to_kindergarten_participation_correlates_with_high_school_graduation
    assert_respond_to(@ha, :kindergarten_participation_correlates_with_high_school_graduation)
  end

  def test_headcount_analyst_responds_to_kindergarten_participation_against_high_school_graduation
    assert_respond_to(@ha, :kindergarten_participation_against_high_school_graduation)
  end

  def test_headcount_analyst_responds_to_top_statewide_test_year_over_year_growth
    assert_respond_to(@ha_test, :top_statewide_test_year_over_year_growth)
  end

  def test_kindergarten_participation_rate_variation_returns_right_value
    result = @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 0.766, result
  end

  def test_can_average_years_from_district_hash
    district = @dr.find_by_name("ACADEMY 20")
    district_years = @ha.district_kindergarten_by_year(district)
    assert_equal 0.4065454545454545, @ha.find_average_years_for_district(district_years)
  end

  def test_find_variation
    assert_equal 0.333, @ha.find_variation([0.25, 0.75])
  end

  def test_can_compare_hs_graduation_to_kindergarten_enrollment_in_a_district
    result = @ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
    assert_equal 0.641, result
  end

  def test_can_tell_if_graduation_correlates_to_kindergarten_for_district
    assert @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_can_correlate_statewide
    refute @ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  end

  def test_find_all_correlations_returns_count_of_true_for_all_district
    result = @ha.count_all_correlations
    assert_instance_of Fixnum, result
    assert result < 180
  end

  def test_can_correlate_across_districts
    result = @ha.kindergarten_participation_correlates_with_high_school_graduation(:across => ['ACADEMY 20', 'ADAMS COUNTY 14', 'ADAMS-ARAPAHOE 28J'])
    refute result
  end

  def test_raises_error_if_missing_grade_arg
    assert_raises(InsufficientInformationError){@ha_test.top_statewide_test_year_over_year_growth(subject: :math)}
  end

  def test_raises_error_if_grade_not_allowed
    assert_raises(UnknownDataError){@ha_test.top_statewide_test_year_over_year_growth(grade: 10)}
  end

  # def test_allows_grade
  #   assert_raises(UnknownDataError){@ha_test.top_statewide_test_year_over_year_growth(grade: 8)}
  # end

  def test_get_districts_and_growths
    assert_instance_of Array, @ha_test.get_districts_and_growths(3, :math)
  end

  def test_get_districts_and_growths_has_district_data_pair
    assert_equal 'ACADEMY 20', @ha_test.get_districts_and_growths(3, :math)[1][:name]
  end

  def test_can_find_top_statewide_test_year_over_year_growth
    skip
    expected = 0.123
    result = @ha_test.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal expected, result
  end

  # def find_single_top_district_growth
  #   expected = 0
  #   assert_equal expected, @ha_test.find_single_top_district_growth(@ha_test.get_districts_and_growths(3, :math))
  # end
end
