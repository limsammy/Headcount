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
    # build_tests
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
      enrollment = @district_repository.find_by_name(district_name).enrollment
      d_k_part = enrollment.kindergarten_participation_by_year.sort.to_h
      d_k_part_against_co = analyst.kindergarten_participation_rate_variation(district_name, :against => 'COLORADO')
      district_index = erb_template.result(binding)
      build_erb(district_index, district_slug, "enrollment.html")
    end
  end

  private
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
