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

  def test_responds_to_create_economic_profile
    assert_respond_to(@epr, :create_economic_profile)
  end

  def test_find_by_name_returns_economic_profile
    skip
    assert_equal 0, @epr.data.length
    @epr.create_economic_profile("DISTRICT 1")
    economic_profile = @epr.find_by_name("DISTRICT 1")
    assert_equal 1, @epr.data.length
    assert_equal economic_profile, @epr.data[0]
  end

  def test_responds_to_process_data
    assert_respond_to(@epr, :process_data)
  end

  def test_create_economic_profile_adds_economic_profile_object_to_data
    skip
    economic_profile = @epr.create_economic_profile(@economic_profile_data)
    assert_equal 1, @epr.data.length
    assert_instance_of EconomicProfile, @epr.data[0]
  end

  def test_find_by_name_returns_economic_profile
    skip
    assert_equal 0, @epr.data.length
    economic_profile = @epr.create_economic_profile(@economic_profile_data)
    assert_equal 1, @epr.data.length
    economic_profile = @epr.find_by_name("DISTRICT 1")
    assert_equal economic_profile, @epr.data[0]
  end

  def test_load_data_returns_array
    # skip
    result = @epr.load_data(@economic_profile_args)
    assert_instance_of Array, result
    assert_equal 181, result.length
  end
end
