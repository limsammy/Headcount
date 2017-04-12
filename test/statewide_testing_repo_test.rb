require_relative 'test_helper'

class StatewideTestingRepositoryTest < MiniTest::Test
  attr_reader :er

  def setup
    @er = StatewideTestingRepository.new
    @statewide_testing_args = {:statewide_testing => {
      :third_grade  => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math         => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }}
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
    assert @er
  end

  def test_initializes_with_no_data
    assert_empty @er.data
  end

  def test_responds_to_load_file
    assert_respond_to(@er, :load_data)
  end

  def test_responds_to_find_by_name
    assert_respond_to(@er, :find_by_name)
  end

  def test_responds_to_create_statewide_test
    assert_respond_to(@er, :create_statewide_test)
  end

  def test_responds_to_process_data
    assert_respond_to(@er, :process_data)
  end

  def test_create_statewide_test_adds_statewide_test_object_to_data
    statewide_test = @er.create_statewide_test(@statewide_test_data)
    assert_equal 1, @er.data.length
    assert_instance_of StatewideTest, @er.data[0]
  end

  def test_find_by_name_returns_statewide_test
    assert_equal 0, @er.data.length
    statewide_test = @er.create_statewide_test(@statewide_test_data)
    assert_equal 1, @er.data.length
    statewide_test = @er.find_by_name("DISTRICT 1")
    assert_equal statewide_test, @er.data[0]
  end

  def test_load_data_returns_array
    result = @er.load_data(@statewide_test_args)
    assert_instance_of Array, result
    assert_equal 181, result.length
  end
end
