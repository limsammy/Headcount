require_relative 'test_helper'

class EnrollmentBuilderTest < MiniTest::Test
  attr_reader :eb

  def setup
    @eb = EnrollmentBuilder.new
  end

  def test_responds_to_create_enrollment
    assert_respond_to(@er, :create_enrollment)
  end

  def test_responds_to_process_data
    assert_respond_to(@er, :process_data)
  end

  def test_create_enrollment_adds_enrollment_object_to_data
    enrollment = @er.create_enrollment(@enrollment_data)
    assert_equal 1, @er.data.length
    assert_instance_of Enrollment, @er.data[0]
  end
end
