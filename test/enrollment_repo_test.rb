require_relative 'test_helper'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < MiniTest::Test
  attr_reader :er

  def setup
    @er = EnrollmentRepository.new
  end

  def test_enrollment_repo_exists
    assert @er
  end

  def test_initializes_with_no_data
    assert_empty @er.data
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

  def test_create_enrollment_adds_enrollment_object_to_data
    enrollment = @er.create_enrollment("DISTRICT 1")
    assert_equal 1, @er.data.length
    assert_instance_of Enrollment, @er.data["DISTRICT 1"]
  end

  def test_find_by_name_creates_enrollment_if_none_exists
    assert_equal 0, @er.data.length
    enrollment = @er.find_by_name("DISTRICT 1")
    assert_equal 1, @er.data.length
  end

  def test_find_by_name_returns_enrollment
    assert_equal 0, @er.data.length
    enrollment = @er.find_by_name("DISTRICT 1")
    assert_equal 1, @er.data.length
    assert_equal enrollment, @er.data["DISTRICT 1"]
  end
end
