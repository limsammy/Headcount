require 'erb'
class ViewBuilder
  attr_reader :analyst, :districts

  def initialize(analyst)
    @analyst = analyst
    @district_repository = analyst.district_repository
    @districts = get_districts_for_web
    run
  end

  def run
    build_index
    build_districts
    build_enrollments
    build_testing
    # build_economic
    output_confirmation
  end

  def build_index
    template_main_index = File.read "./views/index.erb"
    erb_template = ERB.new template_main_index
    main_index = erb_template.result(binding)
    build_erb(main_index)
  end

  def build_districts
    template_district_index = File.read "./views/district/index.erb"
    erb_template = ERB.new template_district_index
    districts.each do |district|
      district_name = district[:name]
      district_slug = "districts/" + district[:slug]
      district_index = erb_template.result(binding)
      build_erb(district_index, district_slug)
    end
  end

  def build_enrollments
    template_district_enrollment = File.read "./views/district/enrollment.erb"
    erb_template = ERB.new template_district_enrollment
    districts.each do |district|
      district_name = district[:name]
      district_slug = "districts/" + district[:slug]

      data = gather_enrollment_data(district)

      district_index = erb_template.result(binding)
      build_erb(district_index, district_slug, "enrollment.html")
    end
  end

  def build_testing
    template_district_testing = File.read "./views/district/testing.erb"
    erb_template = ERB.new template_district_testing
    districts.each do |district|
      district_name = district[:name]
      district_slug = "districts/" + district[:slug]

      data = gather_testing_data(district)

      district_index = erb_template.result(binding)
      build_erb(district_index, district_slug, "testing.html")
    end
  end

  private

  def gather_testing_data(district)
    testing = @district_repository.find_by_name(district[:name]).statewide_test
    {
      d_3_by_years: testing.proficient_by_grade(3),
      d_3_by_years_math: get_grade_year_subject_scores(testing, 3, :math),
      d_3_by_years_reading: get_grade_year_subject_scores(testing, 3, :reading),
      d_3_by_years_writing: get_grade_year_subject_scores(testing, 3, :writing),
      d_8_by_years: testing.proficient_by_grade(8),
      d_8_by_years_math: get_grade_year_subject_scores(testing, 8, :math),
      d_8_by_years_reading: get_grade_year_subject_scores(testing, 8, :reading),
      d_8_by_years_writing: get_grade_year_subject_scores(testing, 8, :writing),
      d_race_math_labels: testing.data[:math].keys.map(&:to_s),
      d_race_math_data_all: get_race_data(testing.data[:math]),
      d_race_reading_labels: testing.data[:reading].keys.map(&:to_s),
      d_race_reading_data_all: get_race_data(testing.data[:reading]),
      d_race_writing_labels: testing.data[:writing].keys.map(&:to_s),
      d_race_writing_data_all: get_race_data(testing.data[:writing]),
    }
  end

  def get_grade_year_subject_scores(testing, year, subject)
    results = testing.proficient_by_grade(year)
    results.map do |year, scores|
      scores[subject]
    end
  end

  def get_race_data(scores_by_year)
    data = {
      :all_students     => [],
      :asian            => [],
      :black            => [],
      :"hawaiian/pacific_islander" => [],
      :hispanic         => [],
      :native_american  => [],
      :two_or_more      => [],
      :white            => []
    }
    scores_by_year.each do |year, scores|
      scores.each do |race, score|
        data[race] << score
      end
    end
    data
  end

  def gather_enrollment_data(district)
    enrollment = @district_repository.find_by_name(district[:name]).enrollment
    {
      d_k_part: enrollment.kindergarten_participation_by_year.sort.to_h,
      d_k_part_against_co: analyst.kindergarten_participation_rate_variation(district[:name], :against => 'COLORADO'),
      d_k_part_against_co_trend: analyst.kindergarten_participation_rate_variation_trend(district[:name], :against => 'COLORADO'),
      d_hs_grad: enrollment.graduation_rate_by_year.sort.to_h,
      d_k_part_predict_hs_grad: analyst.kindergarten_participation_correlates_with_high_school_graduation(for: district[:name])
    }
  end

  def build_erb(erb, sub_dir = '', filename = "index.html")
    Dir.mkdir("build") unless Dir.exists? "build"

    if sub_dir != ''
      Dir.mkdir("build/districts") unless Dir.exists? "build/districts"
      if !Dir.exists?("build/#{sub_dir}")
        Dir.mkdir("build/#{sub_dir}")
      end
    end

    filename = "build/" + sub_dir + "/" + filename

    File.open(filename, 'w') do |file|
      file.puts erb
    end
  end

  def get_districts_for_web
    analyst.district_repository.data.map do |district|
      {
        name: district.name,
        slug: make_district_slug(district.name)
      }
    end
  end

  def output_confirmation
    puts "Your App has been built.  Please visit the build folder in this directory and open /build/index.html in your browser."
  end

  def make_district_slug(name)
    name.downcase.gsub(" ", "-").gsub('/','-')
  end
end
