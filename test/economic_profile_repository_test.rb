require_relative 'test_helper'

class EconomicProfileRepositoryTest < MiniTest::Test
  attr_reader :erp

  def setup
    @epr = EconomicProfileRepository.new
    @epr_args = {
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    }
    @economic_profile_data = {
      :name => "DISTRICT 1",
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

  def test_district_repo_exists
    assert @epr
  end

  def test_responds_to_load_file
    assert_respond_to(@epr, :load_data)
  end

  def test_responds_to_find_by_name
    assert_respond_to(@epr, :find_by_name)
  end

  def test_find_by_name_returns_economic_profile
    assert_equal 0, @epr.data.length
    economic_profile = EconomicProfileBuilder.new(@epr).create_economic_profile(@economic_profile_data)
    assert_equal 1, @epr.data.length
    economic_profile = @epr.find_by_name("DISTRICT 1")
    assert_equal @epr.data[0], economic_profile
  end

  def test_load_data_returns_array
    result = @epr.load_data(@epr_args)
    assert_instance_of Array, result
    assert_equal 181, result.length
  end
end
