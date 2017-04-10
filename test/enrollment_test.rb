require_relative 'test_helper'
require_relative '../lib/enrollment'

class EnrollmentTest < MiniTest::Test
  attr_reader :e

  def setup
    @e = Enrollment.new({name: 'Test'})
  end

  def test_district_exists
    assert @e
  end

  def test_district_has_a_name
    assert_equal "Test", @e.name
  end
end
