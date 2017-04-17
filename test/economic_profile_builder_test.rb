require_relative 'test_helper'

class EconomicProfileBuilderTest < MiniTest::Test
  def setup
    @epr = EconomicProfileRepository.new
    @pb = EconomicProfileBuilder.new(@epr)
    @economic_profile_data = {
      :median_household_income => {
        [2005, 2009] => 50000,
        [2008, 2012] => 60000
      },
      :children_in_poverty => {2012 => 0.1845},
      :free_or_reduced_price_lunch => {
        2014 => {
          :percentage => 0.023,
          :total => 100
          }
        },
      :title_i => {2015 => 0.543}
    }
  end

  def test_responds_to_create_economic_profile
    assert_respond_to(@pb, :create_economic_profile)
  end

  def test_responds_to_process_data
    assert_respond_to(@pb, :process_data)
  end

  def test_create_economic_profile_adds_economic_profile_object_to_data
    skip
    economic_profile = @pb.create_economic_profile(@economic_profile_data)
    assert_equal 1, @epr.data.length
    assert_instance_of EconomicProfile, @epr.data[0]
  end

  def test_create_economic_profile_adds_economic_profile_object_to_data
    economic_profile = @pb.create_economic_profile(@economic_profile_data)
    assert_equal 1, @epr.data.length
    assert_instance_of EconomicProfile, @epr.data[0]
  end
end
