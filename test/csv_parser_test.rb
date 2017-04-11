require_relative 'test_helper'
require_relative '../lib/csv_query'

class DummyClass
  include CSVQuery
end

class CSVQueryTest < Minitest::Test
  def test_load_file_method
    skip
    assert_respond_to(DummyClass.new, :load_file)
  end

  def test_load_file_returns_csv_object_of_loaded_file
    skip
    assert_instance_of CSV, DummyClass.new.load_file("./data/Special education.csv")
  end

  def test_get_column_returns_indiciated_column
    skip
    contents = DummyClass.new.load_file("./data/Special education.csv")
    column = DummyClass.new.get_column(contents, :location)
    column = column[0].to_s

    assert_includes "Colorado", column
  end

  def test_csv_to_hash_returns_hash_of_data
    skip
    contents = DummyClass.new.load_file("./data/Special education.csv")
    assert_equal 1086, DummyClass.new.csv_to_hash(contents).count
  end

  def test_format_percent_creates_float_and_rounds_to_3_decimals
    skip
    sample_num = 2.545195857435
    assert_instance_of Float, DummyClass.new.format_percent(sample_num)
    assert_equal 2.545, DummyClass.new.format_percent(sample_num)
  end

  def test_sanitize_data_header
    skip
    contents = DummyClass.new.load_file("./data/Special education.csv")
    assert_equal 0.101, DummyClass.new.sanitize(contents, :data) #[4] # [:data]
  end

  def test_sanitize_location_case
    skip
    contents = DummyClass.new.load_file("./data/Special education.csv")
    assert_equal "COLORADO", DummyClass.new.sanitize(contents, :location)[0][:location]
  end

  def test_find_specific_records
    contents = DummyClass.new.load_file("./data/Special education.csv")
    search = {search_in: "location", find:"Colorado"}
    expected = [{:location=>"Colorado", :timeframe=>"2009", :dataformat=>"Percent", :data=>"0.096"}, {:location=>"Colorado", :timeframe=>"2011", :dataformat=>"Percent", :data=>"0.097"}, {:location=>"Colorado", :timeframe=>"2012", :dataformat=>"Number", :data=>"84410"}, {:location=>"Colorado", :timeframe=>"2012", :dataformat=>"Percent", :data=>"0.098"}, {:location=>"Colorado", :timeframe=>"2013", :dataformat=>"Percent", :data=>"0.10056"}, {:location=>"Colorado",:timeframe=>"2010",:dataformat=>"Percent", :data=>"0.096"}, {:location=>"Colorado", :timeframe=>"2014", :dataformat=>"Number", :data=>"89602"}, {:location=>"Colorado", :timeframe=>"2014", :dataformat=>"Percent", :data=>"0.10079"}]
    assert_equal expected, DummyClass.new.find_records(contents, search)
  end
end
