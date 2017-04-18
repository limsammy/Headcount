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

    @headcount_seed_data = {
      :name => "HEADCOUNT TEST",
      :third_grade => {
        2008 => {
          :math    => 0.697,
          :reading => 0.703,
          :writing => 0.501
        },
        2009 => {
          :math    => 0.691,
          :reading => 0.726,
          :writing => 0.536
        },
        2010 => {
          :math    => 0.706,
          :reading => 0.698,
          :writing => 0.514
        }
      },
      :eighth_grade => {
        2008 => {
          :math    => 0.469,
          :reading => 0.703,
          :writing => 0.529
        },
        2009 => {
          :math    => 0.499,
          :reading => 0.726,
          :writing => 0.528
        },
        2010 => {
          :math    => 0.510,
          :reading => 0.679,
          :writing => 0.549
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
    @swt1 = StatewideTest.new(@headcount_seed_data)
  end

  def test_statewide_test_exists
    assert @swt
  end

  def test_statewide_test_has_a_name
    assert_equal "TEST", @swt.name
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

  def test_swt_responds_to_proficient_by_grade
    assert_respond_to @swt, :proficient_by_grade
  end

  def test_swt_by_grade_raises_error_if_not_3_or_8
    assert_raises(UnknownDataError){@swt.proficient_by_grade(4)}
  end

  def test_swt_by_grade_returns_proficiency_for_3rd
    expected = {2008 => {
      :math    => 0.697,
      :reading => 0.703,
      :writing => 0.501
    }}
    result = @swt.proficient_by_grade(3)
    assert_equal expected, result
  end

  def test_swt_responds_to_proficient_by_race_or_ethnicity
    assert_respond_to @swt, :proficient_by_race_or_ethnicity
  end

  def test_swt_by_race_raises_error_if_not_in_allowed
    assert_raises(UnknownDataError){@swt.proficient_by_race_or_ethnicity(:blue)}
  end

  def test_swt_by_grade_returns_proficiency_for_asian
    result = @swt.proficient_by_race_or_ethnicity(:asian)
    expected = { 2011 => {:math=>0.7094, :reading=>0.7482, :writing=>0.6569}}
    assert_equal expected, result
  end

  def test_swt_responds_to_proficient_for_subject_by_grade_in_year
    assert_respond_to @swt, :proficient_for_subject_by_grade_in_year
  end

  def test_swt_by_grade_in_year_raises_error_for_grade
    assert_raises(UnknownDataError){@swt.proficient_for_subject_by_grade_in_year(:math, 4, 2012)}
  end

  def test_swt_by_grade_in_year_raises_error_for_bad_subject
    assert_raises(UnknownDataError){@swt.proficient_for_subject_by_grade_in_year(:literature, 3, 2012)}
  end

  def test_swt_by_grade_in_year_raises_error_for_unknown_year
    assert_raises(UnknownDataError){@swt.proficient_for_subject_by_grade_in_year(:math, 3, 2000)}
    assert_raises(UnknownDataError){@swt.proficient_for_subject_by_grade_in_year(:math, 3, 3000)}
  end

  def test_swt_by_grade_in_year_returns_proficiency_for_math_3_2008
    result = @swt.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
    expected = 0.697
    assert_equal expected, result
  end

  def test_swt_responds_to_proficient_for_subject_by_race_in_year
    assert_respond_to @swt, :proficient_for_subject_by_race_in_year
  end

  def test_swt_by_grade_in_year_raises_error_if_not_in_allowed_race
    assert_raises(UnknownDataError){@swt.proficient_for_subject_by_race_in_year(:math, :blue, 2012)}
  end

  def test_swt_by_grade_in_year_raises_error_if_not_in_allowed_subject
    assert_raises(UnknownDataError){@swt.proficient_for_subject_by_race_in_year(:literature, :white, 2012)}
  end

  def test_swt_by_grade_in_year_raises_error_for_unknown_year
    assert_raises(UnknownDataError){@swt.proficient_for_subject_by_race_in_year(:math, :white, 2000)}
    assert_raises(UnknownDataError){@swt.proficient_for_subject_by_race_in_year(:math, :white, 3000)}
  end

  def test_swt_by_grade_in_year_returns_proficiency_for_math_asian_2011
    result = @swt.proficient_for_subject_by_race_in_year(:math, :asian, 2011)
    expected = 0.7094
    assert_equal expected, result
  end

  # def test_find_by_category_finds_third_grade_seed_data => depreciated
  #   result = @swt1.find_by_category(3)[2008][:math]
  #   expected = 0.697
  #   assert_equal expected, result
  # end

  # def test_find_by_category_finds_eighth_grade_seed_data => depreciated
  #   result = @swt1.find_by_category(8)[2008][:math]
  #   expected = 0.469
  #   assert_equal expected, result
  # end

  def test_find_by_category_finds_third_grade_data_of_subject
    expected = {
      2008 => 0.697,
      2009 => 0.691,
      2010 => 0.706
    }
    assert_equal expected, @swt1.find_by_category(3, :math)
  end

  def test_find_by_category_finds_eighth_grade_data_of_subject
    expected = {
      2008 => 0.469,
      2009 => 0.499,
      2010 => 0.510
    }
    assert_equal expected, @swt1.find_by_category(8, :math)
  end

  def test_find_growth_over_years_for_eighth_grade_math
    expected = 0.021
    assert_equal expected, @swt1.growth_by_grade_over_years(8, :math)
  end

  def test_find_growth_over_years_for_third_grade_math
    expected = 0.005
    assert_equal expected, @swt1.growth_by_grade_over_years(3, :math)
  end

  def test_find_by_category_will_find_all_subjects_for_grade
    expected = {2008=>1.9009999999999998,
                2009=>1.9529999999999998,
                2010=>1.918}
    result = @swt1.find_by_category(3)
    assert_equal expected, result
  end

  def test_get_all_subjects_for_grade_by_year_returns_correct_output
    expected = {2008=>1.9009999999999998,
                2009=>1.9529999999999998,
                2010=>1.918}
    result = @swt1.get_all_subjects_for_grade_by_year(:third_grade)
    assert_equal expected, result
  end

  # def test_average_growth_across_years
  #   result = @swt1.average_growth_across_years(:third_grade)
  #   assert_equal 2, result
  # end
end
