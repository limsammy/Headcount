class EconomicProfile
  attr_reader :name

  def initialize(args)
    @name = args[:name]
    args.delete(:name)
    @data = args
  end

  def update_data(args)
    args.delete(:name)
    args.each do |category, value|
      if @data[category].nil?
        @data[category] = value
      else
        @data[category].merge!(value)
      end
    end
  end
end
