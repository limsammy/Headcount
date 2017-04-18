class EconomicProfile
  attr_reader :name, 
              :data

  def initialize(args)
    @name = args[:name]
    args.delete(:name)
    @data = args
  end

  def validate_args(args)
    valid = {
      :median_income_years => available_median_income_years,
      :children_in_poverty_years => @data[:children_in_poverty].keys,
      :free_or_reduced_years => @data[:free_or_reduced_price_lunch].keys,
      :title_i_years => @data[:title_i].keys
    }
    args.each do |set, value|
      raise UnknownDataError unless valid[set].include?(value)
    end
  end

  def median_household_income_in_year(year)
    validate_args({median_income_years:year})
    years = @data[:median_household_income]
    incomes = find_median_incomes_between(years,year)
    average_array(incomes.values)
  end

  def median_household_income_average
    incomes = @data[:median_household_income].values
    average_array(incomes)
  end

  def children_in_poverty_in_year(year)
    validate_args({children_in_poverty_years:year})
    @data[:children_in_poverty][year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    validate_args({free_or_reduced_years:year})
    # binding.pry
    @data[:free_or_reduced_price_lunch][year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    validate_args({free_or_reduced_years:year})
    @data[:free_or_reduced_price_lunch][year][:total]
  end

  def average_number_of_lunch_students
    lunch_data = @data[:free_or_reduced_price_lunch]
    students = sum_lunch_student_totals(lunch_data.values)
    students / lunch_data.length
  end

  def title_i_in_year(year)
    validate_args({title_i_years:year})
    @data[:title_i][year]
  end

  def update_data(args, look_in = @data)
    args.delete(:name) if args.key?(:name)
    args.each do |category, value|
      if look_in[category].nil?
        look_in[category] = value
      else
        update_data(value, look_in[category])
      end
    end
  end

  private

  def find_median_incomes_between(years, year)
    years.select do |years, income|
      year.between?(years[0], years[1])
    end
  end

  def average_array(numbers)
    numbers.reduce(&:+) / numbers.length
  end

  def available_median_income_years
    our_years = @data[:median_household_income].keys.flatten.sort
    [*(our_years.first..our_years.last)]
  end

  def sum_lunch_student_totals(totals)
    totals = totals.reject{|value| value[:total].class == String}
    totals.reduce(0) {|sum, value| sum + value[:total]}
  end
end
