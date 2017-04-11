require_relative 'test_helper'
require_relative '../lib/enrollment'

class EnrollmentTest < MiniTest::Test
  attr_reader :e

  def setup
    @e = Enrollment.new({name: 'Test', :kindergarten_participation => {2010 => 0.3915}})
  end

  def test_district_exists
    assert @e
  end

  def test_district_has_a_name
    assert_equal "Test", @e.name
  end

  def test_update_data_add_data_to_category
    args = {:name => "ACADEMY 20", :kindergarten_participation => {2011 => 0.35356}}
    @e.update_data(args)
  end
end
