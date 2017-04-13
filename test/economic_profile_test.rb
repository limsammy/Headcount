require_relative 'test_helper'

class EconomicProfileTest < MiniTest::Test
  attr_reader :ep

  def setup
    @ep = EconomicProfile.new(
      {name: 'Test',
        :median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
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
end
