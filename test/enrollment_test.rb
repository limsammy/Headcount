require_relative 'test_helper'


class EnrollmentTest < MiniTest::Test
  attr_reader :e

  def setup
    @e = Enrollment.new({name: 'TEST', :kindergarten_participation => {2010 => 0.3915}})
  end

  def test_enrollment_exists
    assert @e
  end

  def test_respond_to_kindergarten_participation_by_year
    assert_respond_to(@e, :kindergarten_participation_by_year)
  end

  def test_respond_to_kindergarten_partiipation_by_specific_year
    assert_respond_to(@e, :kindergarten_participation_in_year)
  end

  def test_respond_to_graduation_rate_by_year
    assert_respond_to(@e, :graduation_rate_by_year)
  end

  def test_respond_to_graduation_rate_in_specific_year
    assert_respond_to(@e, :graduation_rate_in_year)
  end

  def test_respond_to_update_data
    assert_respond_to(@e, :update_data)
  end

  def test_enrollment_has_a_name
    assert_equal "Test", @e.name
  end

  def test_can_get_participation_by_year
    args = {:name => "TEST", :kindergarten_participation => {2011 => 0.35356}}
    @e.update_data(args)
    k_data_by_year = @e.kindergarten_participation_by_year
    assert_equal 2, k_data_by_year.length
    assert_equal 0.35356, k_data_by_year[2011]
  end

  def test_can_get_participation_in_year
    args = {:name => "TEST", :kindergarten_participation => {2011 => 0.35356}}
    @e.update_data(args)
    k_data_in_2010 = @e.kindergarten_participation_in_year(2010)
    assert_equal 0.3915, k_data_in_2010
  end
end
