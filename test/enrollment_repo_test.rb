require_relative 'test_helper'
require_relative '../lib/enrollment_repo'

class EnrollmentRepositoryTest < MiniTest::Test
  attr_reader :er

  def setup
    @er = EnrollmentRepository.new
  end

  def test_enrollment_repo_exists
    assert @er
  end

  def test_initializes_with_no_repos
    skip
    assert_nil @er.enrollment_repo
    assert_nil @er.testing_repo
    assert_nil @er.econ_repo
  end

  def test_responds_to_load_file
    assert_respond_to(@er, :load_data)
  end

  def test_responds_to_find_by_name
    assert_respond_to(@er, :find_by_name)
  end

  def test_responds_to_create_district
    assert_respond_to(@er, :create_enrollment)
  end

  def test_create_district_adds_district_object_to_data
    skip
    district = @er.create_district("DISTRICT 1")
    assert_equal 1, @er.data.length
    assert_instance_of District, @er.data["DISTRICT 1"]
  end

  def test_find_by_name_creates_district_if_none_exists
    skip
    assert_equal 0, @er.data.length
    district = @er.find_by_name("DISTRICT 1")
    assert_equal 1, @er.data.length
  end

  def test_find_by_name_returns_district
    skip
    assert_equal 0, @er.data.length
    district = @er.find_by_name("DISTRICT 1")
    assert_equal 1, @er.data.length
    assert_equal district, @er.data["DISTRICT 1"]
  end

  def test_find_all_matching_returns_empty_array
    skip
    assert_equal [], @er.find_all_matching('Test')
  end

  def test_find_all_matching_returns_array_of_found
    skip
    district = @er.find_by_name("District 1")
    district_1 = @er.find_by_name("Test 1")
    district_2 = @er.find_by_name("Test 2")
    districts = @er.find_all_matching("test")
    assert_equal 2, districts.length
    districts.each do |district|
      assert district.name == "TEST 1" || district.name == "TEST 2"
      assert_instance_of District, district
    end
  end
end
