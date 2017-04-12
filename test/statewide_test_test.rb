require_relative 'test_helper'


class StatewideTestTest < MiniTest::Test
  # attr_reader :swt

  def setup
    @swt = Enrollment.new({
      :name => "TEST",
      :third_grade => {
        :math    => {2008 => 0.697},
        :reading => {2008 => 0.703},
        :writing => {2008 => 0.501}
      },
      :eighth_grade => {
        :math    => {2008 => 0.469},
        :reading => {2008 => 0.703},
        :writing => {2008 => 0.529}
      },
      :math => {
        :all_students     => {2011 => 0.5573},
        :asian            => {2011 => 0.7094},
        :black            => {2011 => 0.3333},
        :pacific_islander => {2011 => 0.541},
        :hispanic         => {2011 => 0.3926},
        :native_american  => {2011 => 0.3981},
        :two_or_more      => {2011 => 0.6101},
        :white            => {2011 => 0.6585}
      },
      :reading => {
        :all_students     => {2011 => 0.68},
        :asian            => {2011 => 0.7482},
        :black            => {2011 => 0.4861},
        :pacific_islander => {2011 => 0.6586},
        :hispanic         => {2011 => 0.4984},
        :native_american  => {2011 => 0.527},
        :two_or_more      => {2011 => 0.7438},
        :white            => {2011 => 0.7893}
      },
      :writing => {
        :all_students     => {2011 => 0.5531},
        :asian            => {2011 => 0.6569},
        :black            => {2011 => 0.3701},
        :pacific_islander => {2011 => 0.5583},
        :hispanic         => {2011 => 0.368},
        :native_american  => {2011 => 0.3788},
        :two_or_more      => {2011 => 0.6169},
        :white            => {2011 => 0.6633}
      }
    })

  end

  def test_statewide_test_exists
    assert @swt
  end

  def test_statewide_test_has_a_name
    assert_equal "TEST", @swt.name
  end

  def test_swt_responds_to_proficient_by_grade
    skip
  end

  def test_swt_by_grade_raises_error_if_not_3_or_8
    skip
  end

  def test_swt_by_grade_returns_proficiency_for_3rd
    skip
  end

  def test_swt_responds_to_proficient_by_race_or_ethnicity
    skip
  end

  def test_swt_by_race_raises_error_if_not_in_allowed
    skip
    allowed = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  end

  def test_swt_responds_to_proficient_for_subject_by_grade_in_year
    skip
  end

  def test_swt_by_grade_in_year_raises_error_for_grade
    skip
    allowed = [3, 8]
  end

  def test_swt_by_grade_in_year_raises_error_for_bad_subject
    skip
    allowed = [:math, :reading, :writing]
  end

  def test_swt_by_grade_in_year_raises_error_for_unknown_year
    skip
    too_early = 2000
    too_late = 2020
  end

  def test_swt_responds_to_proficient_for_subject_by_race_in_year
    skip
  end

  def test_swt_by_grade_in_year_raises_error_for_grade
    skip
    allowed = [3, 8]
  end

  def test_swt_by_grade_in_year_raises_error_if_not_in_allowed
    skip
    allowed = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  end

  def test_swt_by_grade_in_year_raises_error_for_unknown_year
    skip
    too_early = 2000
    too_late = 2020
  end
end
