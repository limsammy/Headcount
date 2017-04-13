require_relative 'test_helper'

class StatewideTestBuilderTest < MiniTest::Test
  # attr_reader :er

  def setup
    @swtr = StatewideTestRepository.new
    @builder = StatewideTestBuilder.new(@swtr)
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

  def test_responds_to_create_statewide_test
    assert_respond_to(@builder, :create_statewide_test)
  end

  def test_responds_to_process_data
    assert_respond_to(@builder, :process_data)
  end

  def test_create_statewide_test_adds_statewide_test_object_to_data
    statewide_test = @builder.create_statewide_test(@statewide_test_data)
    assert_equal 1, @swtr.data.length
    assert_instance_of StatewideTest, @swtr.data[0]
  end
end
