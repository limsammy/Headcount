require_relative 'test_helper'
require_relative '../lib/district_repo'

class DistrictRepositoryTest < MiniTest::Test
  attr_reader :dr

  def setup
    @dr = DistrictRepository.new
  end

  def test_district_repo_exists
    assert @dr
  end

  def test_initializes_with_no_repos
    assert_nil @dr.enrollment_repo
    assert_nil @dr.testing_repo
    assert_nil @dr.econ_repo
  end

  def test_responds_to_load_file
    assert_respond_to(@dr, :load_data)
  end

  def test_responds_to_find_by_name
    assert_respond_to(@dr, :find_by_name)
  end

  def test_responds_to_find_all_matching
    assert_respond_to(@dr, :find_all_matching)
  end

  def test_responds_to_create_district
    assert_respond_to(@dr, :create_district)
  end

  def test_create_district_adds_district_object_to_data
    district = @dr.create_district("DISTRICT 1")
    assert_equal 1, @dr.data.length
    assert_instance_of District, @dr.data["DISTRICT 1"]
  end

  def test_find_by_name_creates_district_if_none_exists
    assert_equal 0, @dr.data.length
    district = @dr.find_by_name("DISTRICT 1")
    assert_equal 1, @dr.data.length
  end

  def test_find_by_name_returns_district
    assert_equal 0, @dr.data.length
    district = @dr.find_by_name("DISTRICT 1")
    assert_equal 1, @dr.data.length
    assert_equal district, @dr.data["DISTRICT 1"]
  end

  def test_find_all_matching_returns_empty_array
    assert_equal [], @dr.find_all_matching('Test')
  end

  def test_find_all_matching_returns_array_of_found
    district = @dr.find_by_name("District 1")
    district_1 = @dr.find_by_name("Test 1")
    district_2 = @dr.find_by_name("Test 2")
    districts = @dr.find_all_matching("test")
    assert_equal 2, districts.length
    districts.each do |district|
      assert district.name == "TEST 1" || district.name == "TEST 2"
      assert_instance_of District, district
    end
  end
end
