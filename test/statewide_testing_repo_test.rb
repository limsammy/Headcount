require_relative 'test_helper'

class StatewideTestRepositoryTest < MiniTest::Test
  def setup
    @swtr = StatewideTestRepository.new
    @statewide_testing_args = {
      :statewide_testing => {
        :third_grade  => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math         => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    }
    @statewide_test_data = {
      :name => "DISTRICT 1",
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
        :all_students              => {2011 => 0.5573},
        :asian                     => {2011 => 0.7094},
        :black                     => {2011 => 0.3333},
        :hawaiian_pacific_islander => {2011 => 0.541},
        :hispanic                  => {2011 => 0.3926},
        :native_american           => {2011 => 0.3981},
        :two_or_more               => {2011 => 0.6101},
        :white                     => {2011 => 0.6585}
      },
      :reading => {
        :all_students              => {2011 => 0.68},
        :asian                     => {2011 => 0.7482},
        :black                     => {2011 => 0.4861},
        :hawaiian_pacific_islander => {2011 => 0.6586},
        :hispanic                  => {2011 => 0.4984},
        :native_american           => {2011 => 0.527},
        :two_or_more               => {2011 => 0.7438},
        :white                     => {2011 => 0.7893}
      },
      :writing => {
        :all_students              => {2011 => 0.5531},
        :asian                     => {2011 => 0.6569},
        :black                     => {2011 => 0.3701},
        :hawaiian_pacific_islander => {2011 => 0.5583},
        :hispanic                  => {2011 => 0.368},
        :native_american           => {2011 => 0.3788},
        :two_or_more               => {2011 => 0.6169},
        :white                     => {2011 => 0.6633}
      }
    }
  end

  def test_statewide_testing_repo_exists
    assert @swtr
  end

  def test_initializes_with_no_data
    assert_empty @swtr.data
  end

  def test_responds_to_load_file
    assert_respond_to(@swtr, :load_data)
  end

  def test_responds_to_find_by_name
    assert_respond_to(@swtr, :find_by_name)
  end

  def test_load_data_returns_array
    result = @swtr.load_data(@statewide_testing_args)
    assert_instance_of Array, result
    assert_equal 181, result.length
    assert_includes result, "AULT-HIGHLAND RE-9"
    assert_includes result, "BUFFALO RE-4"
  end

  def test_subject_by_race_in_year_from_harness
    @swtr.load_data(@statewide_testing_args)
    testing = @swtr.find_by_name("AULT-HIGHLAND RE-9")
    assert_in_delta 0.611, testing.proficient_for_subject_by_race_in_year(:math, :white, 2012), 0.005
    assert_in_delta 0.310, testing.proficient_for_subject_by_race_in_year(:math, :hispanic, 2014), 0.005
    assert_in_delta 0.794, testing.proficient_for_subject_by_race_in_year(:reading, :white, 2013), 0.005
    assert_in_delta 0.278, testing.proficient_for_subject_by_race_in_year(:writing, :hispanic, 2014), 0.005

    testing = @swtr.find_by_name("BUFFALO RE-4")
    assert_in_delta 0.65, testing.proficient_for_subject_by_race_in_year(:math, :white, 2012), 0.005
    assert_in_delta 0.437, testing.proficient_for_subject_by_race_in_year(:math, :hispanic, 2014), 0.005
    assert_in_delta 0.76, testing.proficient_for_subject_by_race_in_year(:reading, :white, 2013), 0.005
    assert_in_delta 0.375, testing.proficient_for_subject_by_race_in_year(:writing, :hispanic, 2014), 0.005
  end

  def test_proficiency_by_subject_and_year_when_no_data
    @swtr.load_data(@statewide_testing_args)
    testing = @swtr.find_by_name("PLATEAU VALLEY 50")
    assert_equal "N/A", testing.proficient_for_subject_by_grade_in_year(:reading, 8, 2011)
  end
end
