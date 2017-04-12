require_relative 'test_helper'


class StatewideTestTest < MiniTest::Test
  # attr_reader :swt

  def setup
    @swt_seed_data = {
      :name => "TEST",
      :third_grade => {
        2008 => {
          :math    => 0.697,
          :reading => 0.703,
          :writing => 0.501
        }
      },
      :eighth_grade => {
        2008 => {
          :math    => 0.469,
          :reading => 0.703,
          :writing => 0.529
        }
      },
      :math => {
        2011 => {
          :all_students     => 0.5573,
          :asian            => 0.7094,
          :black            => 0.3333,
          :pacific_islander => 0.541,
          :hispanic         => 0.3926,
          :native_american  => 0.3981,
          :two_or_more      => 0.6101,
          :white            => 0.6585
        }
      },
      :reading => {
        2011 => {
          :all_students     => 0.68,
          :asian            => 0.7482,
          :black            => 0.4861,
          :pacific_islander => 0.6586,
          :hispanic         => 0.4984,
          :native_american  => 0.527,
          :two_or_more      => 0.7438,
          :white            => 0.7893
        }
      },
      :writing => {
        2011 => {
          :all_students     => 0.5531,
          :asian            => 0.6569,
          :black            => 0.3701,
          :pacific_islander => 0.5583,
          :hispanic         => 0.368,
          :native_american  => 0.3788,
          :two_or_more      => 0.6169,
          :white            => 0.6633
        }
      }
    }
    @swt = StatewideTest.new(@swt_seed_data)
  end

  def test_statewide_test_exists
    assert @swt
  end

  def test_statewide_test_has_a_name
    assert_equal "TEST", @swt.name
  end

  def test_swt_responds_to_proficient_by_grade
    assert_respond_to @swt, :proficient_by_grade
  end

  def test_swt_by_grade_raises_error_if_not_3_or_8
    assert_raises(UnknownDataError){@swt.proficient_by_grade(4)}
  end

  def test_can_initialize_with_data
    assert_equal @swt.data[:third_grade], @swt_seed_data[:third_grade]
    assert_equal @swt.data[:eighth_grade], @swt_seed_data[:eighth_grade]
    assert_equal @swt.data[:math], @swt_seed_data[:math]
    assert_equal @swt.data[:reading], @swt_seed_data[:reading]
    assert_equal @swt.data[:writing], @swt_seed_data[:writing]
  end

  def test_can_update_data_third_grade_data
    new_third_grade_math_data = {
      :name => "TEST",
      :third_grade => {
        2009 => {
          :math    => 0.691
        }
      }
    }
    new_third_grade_reading_data = {
      :name => "TEST",
      :third_grade => {
        2009 => {
          :reading => 0.726
        }
      }
    }
    new_third_grade_writing_data = {
      :name => "TEST",
      :third_grade => {
        2009 => {
          :writing => 0.536
        }
      }
    }
    @swt.update_data(new_third_grade_math_data)
    @swt.update_data(new_third_grade_reading_data)
    @swt.update_data(new_third_grade_writing_data)
    assert_equal 0.691, @swt.data[:third_grade][2009][:math]
    assert_equal 0.726, @swt.data[:third_grade][2009][:reading]
    assert_equal 0.536, @swt.data[:third_grade][2009][:writing]
    assert_equal 0.697, @swt.data[:third_grade][2008][:math]
  end

  def test_can_update_data_csap_data
    new_csap_math_data = {
      :name => "TEST",
      :math => {
        2012 => {
          :all_students => 0.558
        }
      }
    }
    @swt.update_data(new_csap_math_data)
    new_csap_math_data = {
      :name => "TEST",
      :math => {
        2012 => {
          :asian => 0.7192
        }
      }
    }
    @swt.update_data(new_csap_math_data)
    new_csap_math_data = {
      :name => "TEST",
      :math => {
        2012 => {
          :black => 0.3359
        }
      }
    }
    @swt.update_data(new_csap_math_data)
    new_csap_math_data = {
      :name => "TEST",
      :math => {
        2012 => {
          :pacific_islander => 0.5055
        }
      }
    }
    @swt.update_data(new_csap_math_data)
    new_csap_math_data = {
      :name => "TEST",
      :math => {
        2012 => {
          :hispanic => 0.3898
        }
      }
    }
    @swt.update_data(new_csap_math_data)
    new_csap_math_data = {
      :name => "TEST",
      :math => {
        2012 => {
          :native_american => 0.4013
        }
      }
    }
    @swt.update_data(new_csap_math_data)
    new_csap_math_data = {
      :name => "TEST",
      :math => {
        2012 => {
          :two_or_more => 0.6145
        }
      }
    }
    @swt.update_data(new_csap_math_data)
    new_csap_math_data = {
      :name => "TEST",
      :math => {
        2012 => {
          :white => 0.6618
        }
      }
    }
    @swt.update_data(new_csap_math_data)
    assert_equal 0.6618, @swt.data[:math][2012][:white]
    assert_equal 0.6145, @swt.data[:math][2012][:two_or_more]
    assert_equal 0.4013, @swt.data[:math][2012][:native_american]
    assert_equal 0.6585, @swt.data[:math][2011][:white]
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
