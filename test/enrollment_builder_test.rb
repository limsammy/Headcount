require_relative 'test_helper'

class EnrollmentBuilderTest < MiniTest::Test
  def setup
    @er = EnrollmentRepository.new
    @eb = EnrollmentBuilder.new(@er)
    @enrollment_data = {:name => "DISTRICT 1", :kindergarten_participation => {2011 => 0.35356}}
  end

  def test_responds_to_create_enrollment
    assert_respond_to(@eb, :create_enrollment)
  end

  def test_responds_to_process_data
    assert_respond_to(@eb, :process_data)
  end

  def test_create_enrollment_adds_enrollment_object_to_data
    enrollment = @eb.create_enrollment(@enrollment_data)
    assert_equal 1, @er.data.length
    assert_instance_of Enrollment, @er.data[0]
  end
end
