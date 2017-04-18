require_relative 'test_helper'

class HeadcountAnalystTest < MiniTest::Test

  def setup
    @dr = DistrictRepository.new
    @dr_args = {
      :enrollment => {
        :kindergarten           => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      },
      :statewide_testing => {
        :third_grade  => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math         => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
    @dr.load_data(@dr_args)
    @ha = HeadcountAnalyst.new(@dr)
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
    assert_respond_to(@ha, :top_statewide_test_year_over_year_growth)
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
    assert_raises(InsufficientInformationError){@ha.top_statewide_test_year_over_year_growth(subject: :math)}
  end

  def test_raises_error_if_grade_not_allowed
    assert_raises(UnknownDataError){@ha.top_statewide_test_year_over_year_growth(grade: 10)}
  end

  def test_get_districts_and_growths
    assert_instance_of Array, @ha.get_districts_and_growths(3, :math)
  end

  def test_get_districts_and_growths_has_district_data_pair
    assert_equal 'ACADEMY 20', @ha.get_districts_and_growths(3, :math)[1][:name]
  end

  def test_can_find_single_top_district_growth
    expected = ['SPRINGFIELD RE-4', 0.149]
    assert_equal expected, @ha.find_single_top_district_growth(@ha.get_districts_and_growths(3, :math))
  end

  def test_can_find_top_statewide_test_year_over_year_growth
    expected = ['SPRINGFIELD RE-4', 0.149]
    result = @ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal expected, result
  end

  def test_find_multiple_top_district_growths_returns_right_amount
    expected = [["SPRINGFIELD RE-4", 0.149], ["WESTMINSTER 50", 0.1], ["CENTENNIAL R-1", 0.088]]
    result = @ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
    assert_equal expected, result
  end

  def test_find_7_top_districts_returns_right_amount
    result = @ha.top_statewide_test_year_over_year_growth(grade: 3, top: 7, subject: :math)
    assert_equal 7, result.count
  end

  def test_top_statewide_works_for_grade
    expected = ['SPRINGFIELD RE-4', 0.399]
    result = @ha.top_statewide_test_year_over_year_growth(grade: 3)
    assert_equal expected, result
  end

  def test_high_high_school_grad_and_high_poverty_creates_resultset
    assert_instance_of ResultSet, @ha.high_poverty_and_high_school_graduation
  end

  def test_high_high_school_grad_and_high_poverty_districts_is_array
    assert_instance_of Array, @ha.high_poverty_and_high_school_graduation.matching_districts
  end

  def test_high_high_school_grad_and_high_poverty_statewide_is_resultentry
    assert_instance_of ResultEntry, @ha.high_poverty_and_high_school_graduation.statewide_average
  end
end
