class EconomicProfile
  attr_reader :name, :data

  def initialize(args)
    @name = args[:name]
    args.delete(:name)
    @data = args
  end

  def median_household_income_in_year(year)

  end

  def median_household_income_average

  end

  def children_in_poverty_in_year(year)

  end

  def free_or_reduced_price_lunch_percentage_in_year(year)

  end

  def free_or_reduced_price_lunch_number_in_year(year)

  end

  def title_i_in_year(year)

  end

  def update_data(args, look_in = @data)
    # binding.pry
    args.delete(:name) if args.key?(:name)
    args.each do |category, value|
      if look_in[category].nil?
        look_in[category] = value
      else
        update_data(value, look_in[category])
      end
    end
  end
end
