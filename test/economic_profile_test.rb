require_relative 'test_helper'

class EconomicProfileTest < MiniTest::Test
  attr_reader :ep

  def setup
    @ep = EconomicProfile.new(
      {name: 'Test',
        :median_household_income => {[2005, 2009] => 50000, [2008, 2012] => 60000},
        :children_in_poverty => {2000 => 0.1845, 2012 => 0.2045},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}, 2001 => {:percentage => 0.203, :total => 1000}},
        :title_i => {2014 => 0.543}
        }
      )
  end

  def test_economic_profile_exists
    assert @ep
  end

  def test_respond_to_update_data
    assert_respond_to(@ep, :update_data)
  end

  def test_economic_profile_has_a_name
    assert_equal "Test", @ep.name
  end

  def test_can_update_data
    new_2000_percentage_data = {name: 'Test', :free_or_reduced_price_lunch => {2000 => {:percentage => 0.027}}}
    new_2000_total_data = {name: 'Test', :free_or_reduced_price_lunch => {2000 => {:total => 195149}}}
    new_median_2006_2010 = {name: 'Test', :median_household_income => {[2006, 2010] => 56456}}
    new_median_2007_2011 = {name: 'Test', :median_household_income => {[2007, 2011] => 57685}}
    @ep.update_data(new_2000_percentage_data)
    @ep.update_data(new_2000_total_data)
    @ep.update_data(new_median_2006_2010)
    @ep.update_data(new_median_2007_2011)
    assert_equal 0.027, @ep.data[:free_or_reduced_price_lunch][2000][:percentage]
    assert_equal 0.023, @ep.data[:free_or_reduced_price_lunch][2014][:percentage]
    assert_equal 195149, @ep.data[:free_or_reduced_price_lunch][2000][:total]
    assert_equal 100, @ep.data[:free_or_reduced_price_lunch][2014][:total]
    assert_equal 56456, @ep.data[:median_household_income][[2006, 2010]]
    assert_equal 57685, @ep.data[:median_household_income][[2007, 2011]]
    assert_equal 60000, @ep.data[:median_household_income][[2008, 2012]]
  end

  def test_respond_to_median_household_income_in_year
    assert_respond_to(@ep, :median_household_income_in_year)
  end

  def test_median_income_in_year_return_error_for_unknown_year
    assert_raises(UnknownDataError){@ep.median_household_income_in_year(2004)}
    assert_raises(UnknownDataError){@ep.median_household_income_in_year(2014)}
  end

  def test_median_income_in_year_returns_integer
    assert_instance_of Fixnum, @ep.median_household_income_in_year(2005)
  end

  def test_median_income_in_year_returns_correct_average
    assert_equal 55000, @ep.median_household_income_in_year(2008)
    assert_equal 60000, @ep.median_household_income_in_year(2010)
  end

  def test_respond_to_median_household_income_average
    assert_respond_to(@ep, :median_household_income_average)
  end

  def test_median_household_income_averages_known_incomes
    assert_equal 55000, @ep.median_household_income_average
  end

  def test_respond_to_children_in_poverty_in_year
    assert_respond_to(@ep, :children_in_poverty_in_year)
  end

  def test_children_in_poverty_raises_error_for_unknown_year
    assert_raises(UnknownDataError){@ep.children_in_poverty_in_year(1994)}
    assert_raises(UnknownDataError){@ep.children_in_poverty_in_year(2014)}
  end

  def test_children_in_poverty_in_year_returns_float
    assert_instance_of Float, @ep.children_in_poverty_in_year(2000)
  end

  def test_children_in_poverty_in_year_returns_value
    assert_equal 0.1845, @ep.children_in_poverty_in_year(2000)
    assert_equal 0.2045, @ep.children_in_poverty_in_year(2012)
  end

  def test_respond_to_free_or_reduced_price_lunch_percentage_in_year
    assert_respond_to(@ep, :free_or_reduced_price_lunch_percentage_in_year)
  end

  def test_free_or_reduced_price_lunch_percentage_raises_error_for_unknown_year
    assert_raises(UnknownDataError){@ep.free_or_reduced_price_lunch_percentage_in_year(1999)}
    assert_raises(UnknownDataError){@ep.free_or_reduced_price_lunch_percentage_in_year(2015)}
  end

  def test_free_or_reduced_price_lunch_percentage_in_year_returns_integer
    assert_instance_of Float, @ep.free_or_reduced_price_lunch_percentage_in_year(2001)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year_returns_value
    assert_equal 0.023, @ep.free_or_reduced_price_lunch_percentage_in_year(2014)
    assert_equal 0.203, @ep.free_or_reduced_price_lunch_percentage_in_year(2001)
  end

  def test_respond_to_free_or_reduced_price_lunch_number_in_year
    assert_respond_to(@ep, :free_or_reduced_price_lunch_number_in_year)
  end

  def test_free_or_reduced_price_lunch_number_raises_error_for_unknown_year
    assert_raises(UnknownDataError){@ep.free_or_reduced_price_lunch_number_in_year(1999)}
    assert_raises(UnknownDataError){@ep.free_or_reduced_price_lunch_number_in_year(2015)}
  end

  def test_free_or_reduced_price_lunch_number_in_year_returns_integer
    assert_instance_of Fixnum, @ep.free_or_reduced_price_lunch_number_in_year(2001)
  end

  def test_free_or_reduced_price_lunch_number_in_year_returns_value
    assert_equal 100, @ep.free_or_reduced_price_lunch_number_in_year(2014)
    assert_equal 1000, @ep.free_or_reduced_price_lunch_number_in_year(2001)
  end

  def test_respond_to_title_i_in_year
    assert_respond_to(@ep, :title_i_in_year)
  end

  def test_title_i_in_year_raises_error_for_unknown_year
    assert_raises(UnknownDataError){@ep.title_i_in_year(1999)}
    assert_raises(UnknownDataError){@ep.title_i_in_year(2015)}
  end

  def test_title_i_in_year_returns_integer
    assert_instance_of Float, @ep.title_i_in_year(2014)
  end

  def test_title_i_in_year_returns_value
    assert_equal 0.543, @ep.title_i_in_year(2014)
  end
end
