require_relative 'test_helper'

class EconomicProfileTest < MiniTest::Test
  attr_reader :ep

  def setup
    @ep = EconomicProfile.new(
      {name: 'Test',
        :median_household_income => {[2005, 2009] => 50000, [2008, 2012] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543}
        }
      )
  end

  def test_economic_profile_exists
    assert @ep
  end

  # def test_respond_to_kindergarten_participation_by_year
  #   assert_respond_to(@ep, :kindergarten_participation_by_year)
  # end

  def test_respond_to_update_data
    assert_respond_to(@ep, :update_data)
  end

  def test_economic_profile_has_a_name
    assert_equal "Test", @ep.name
  end

  def test_can_update_data_lunch_data
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
end
