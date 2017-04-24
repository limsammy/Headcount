require 'erb'
require 'nokogiri'
require 'httparty'
class ViewBuilder
  attr_reader :analyst, :districts

  def initialize(analyst)
    @analyst = analyst
    @district_repository = analyst.district_repository
    @districts = get_districts_for_web
    page = HTTParty.get('https://en.wikipedia.org/wiki/List_of_school_districts_in_Colorado')
    @district_page = Nokogiri::HTML(page)
    run
  end

  def run
    build_index
    build_districts
    build_enrollments
    build_testing
    build_economic
    build_analyst
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
      link_to_district = find_district_link(district_name)
      info_box = ''
      if !link_to_district.nil? && !link_to_district.empty?
        page = HTTParty.get("https://en.wikipedia.org" + link_to_district)
        parse_file = Nokogiri::HTML(page)
        info_box = parse_file.css('.infobox').to_html
        info_source = "https://en.wikipedia.org#{link_to_district}"
      end
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

  def build_economic
    template_district_economic = File.read "./views/district/economic.erb"
    erb_template = ERB.new template_district_economic
    districts.each do |district|
      district_name = district[:name]
      district_slug = "districts/" + district[:slug]

      data = gather_economic_data(district)

      district_index = erb_template.result(binding)
      build_erb(district_index, district_slug, "economic.html")
    end
  end

  def build_analyst
    template_analyst = File.read "./views/headcount.erb"
    erb_template = ERB.new template_analyst

    top_3rd_grade = analyst.top_statewide_test_year_over_year_growth(grade: 3)
    third_grade = @district_repository.find_by_name(top_3rd_grade[0]).statewide_test
    top_8th_grade = analyst.top_statewide_test_year_over_year_growth(grade: 8)
    eigth_grade = @district_repository.find_by_name(top_8th_grade[0]).statewide_test
    data = {
      d_3_by_years: third_grade.proficient_by_grade(3),
      d_3_by_years_math: get_grade_year_subject_scores(third_grade, 3, :math),
      d_3_by_years_reading: get_grade_year_subject_scores(third_grade, 3, :reading),
      d_3_by_years_writing: get_grade_year_subject_scores(third_grade, 3, :writing),
      d_8_by_years: eigth_grade.proficient_by_grade(8),
      d_8_by_years_math: get_grade_year_subject_scores(eigth_grade, 8, :math),
      d_8_by_years_reading: get_grade_year_subject_scores(eigth_grade, 8, :reading),
      d_8_by_years_writing: get_grade_year_subject_scores(eigth_grade, 8, :writing),
    }
    top_3rd_math = analyst.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
    top_3rd_reading = analyst.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :reading)
    top_3rd_writing = analyst.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :writing)
    top_8th_math = analyst.top_statewide_test_year_over_year_growth(grade: 8, top: 3, subject: :math)
    top_8th_reading = analyst.top_statewide_test_year_over_year_growth(grade: 8, top: 3, subject: :reading)
    top_8th_writing = analyst.top_statewide_test_year_over_year_growth(grade: 8, top: 3, subject: :writing)
    high_poverty_and_grad_rate_rs = analyst.high_poverty_and_high_school_graduation
    high_poverty_and_grad_rate = high_poverty_and_grad_rate_rs.matching_districts
    income_disparity_rs = analyst.high_income_disparity
    income_disparity = income_disparity_rs.matching_districts

    analyst = erb_template.result(binding)
    build_erb(analyst, '', 'headcount.html')
  end

  private

  def gather_economic_data(district)
    economic = @district_repository.find_by_name(district[:name]).economic_profile
    {
      d_children_in_poverty: economic.data[:children_in_poverty] || {},
      d_title_i: economic.data[:title_i],
      d_median_income: economic.data[:median_household_income],
      d_lunch_precentage: get_lunch_data(economic, :percentage).sort.to_h,
      d_lunch_total: get_lunch_data(economic, :total).sort.to_h,
    }
  end

  def get_lunch_data(economic, measure)
    results = economic.data[:free_or_reduced_price_lunch]
    data = {}
    results.each do |year, scores|
       data[year] = scores[measure]
    end
    data
  end

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
    Dir.mkdir("docs") unless Dir.exists? "docs"

    if sub_dir != ''
      Dir.mkdir("docs/districts") unless Dir.exists? "docs/districts"
      if !Dir.exists?("docs/#{sub_dir}")
        Dir.mkdir("docs/#{sub_dir}")
      end
    end

    filename = "docs/" + sub_dir + "/" + filename

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

  def find_district_link(name)
    return '' if name == "COLORADO"
    first_word = name.split(" ").first.downcase.capitalize
    @district_page.xpath("//a[contains(text(), '#{first_word}')]")[0]["href"] if @district_page.xpath("//a[contains(text(), '#{first_word}')]")[0]
  end
end
