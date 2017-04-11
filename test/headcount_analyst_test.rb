require_relative 'test_helper'

class HeadcountAnalystTest < MiniTest::Test

  def setup
    @dr = DistrictRepository.new
    @dr_args = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    @dr.load_data(@dr_args)
    @ha = HeadcountAnalyst.new(@dr)
  end

  def test_headcount_analyst_exists
    assert_instance_of HeadcountAnalyst, @ha
  end

  def test_headcount_analyst_responds_to_kindergarten_participation_rate_variation
    assert_respond_to(@ha, :kindergarten_participation_rate_variation)
  end

  def test_kindergarten_participation_rate_variation_can_compare_to_colorado
    result = @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 0.766, result
  end

  def test_can_average_years_from_district_hash
    district = @dr.find_by_name("ACADEMY 20")
    assert_equal 0.4065454545454545, @ha.find_average_years_for_district(district)
  end

  def test_enforce_percentage
    assert_equal 0.407, @ha.enforce_percentage(0.4065454545454545)
  end

  def test_kindergarten_participation_rate_variation_can_compare_against_yuma
    result = @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    assert_equal 0.447, result
  end

  def test_rate_variation_trend_can_compare_to_colorado
    result = @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    expected = {2004 => 1.258, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.718, 2009 => 0.652, 2010 => 0.681, 2011 => 0.728, 2012 => 0.689, 2013 => 0.694, 2014 => 0.661 }
    assert_equal expected, result
  end
end
