require 'pry'
require 'pry-state'
def get_category_by_years(data, criteria, category)
  data[category].map do |year, breakdown|
    {year => {category => breakdown[criteria]}}
  end
end

math = {
  :math => {
    2011 => {:all => 0, :black => 1},
    2012 => {:all => 1, :black => 3},
    2013 => {:all => 15, :black => 35}
    }
  }
reading = {
  :reading => {
    2011 => {:all => 0, :black => 1},
    2012 => {:all => 1, :black => 3},
    2013 => {:all => 10, :black => 30}
    }
  }
writing = {
  :writing => {
    2011 => {:all => 0, :black => 1},
    2012 => {:all => 1, :black => 3},
    2013 => {:all => 10, :black => 30}
    }
  }
math_years = get_category_by_years(math, :black, :math)
reading_years = get_category_by_years(reading, :black, :reading)
writing_years = get_category_by_years(writing, :black, :writing)
years = math_years + reading_years + writing_years
groups = years.group_by{ |o| o.keys.first }.map { |key, v| [key, v.map(&:values).flatten] }.to_h
flattened = groups.map do |k, v|
  {k => v.reduce({}) {|h,pairs| pairs.each {|k,v| h[k] = v }; h }}
end
final = flattened.reduce({}) do |h, sets|
  h.merge(sets)
end
binding.pry
''
# year.map {|key, hash| [hash.keys.first, hash.values.first]}.to_h

# {
#   2011=>{:math=>[1], :reading=>[1]},
#   2012=>{:math=>[3], :reading=>[3]},
#   2013=>{:math=>[35], :reading=>[30]}
# }

# {
#   2011=>[{:math=>1}, {:reading=>1}],
#   2012=>[{:math=>3}, {:reading=>3}]
# }
