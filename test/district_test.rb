require_relative 'test_helper'


class DistrictTest < MiniTest::Test
  attr_reader :d

  def setup
    @d = District.new({name: 'Test'})
  end

  def test_district_exists
    assert @d
  end

  def test_district_has_a_name
    assert_equal "Test", @d.name
  end
end
