require_relative 'test_helper'


class DummyClass
  include CSVParser
end

class CSVQueryTest < Minitest::Test
  def setup
    @dummy = DummyClass.new
  end

  def test_respond_to_parse_file
    assert_respond_to(@dummy, :parse_file)
  end

  def test_respond_to_format_percent
    assert_respond_to(@dummy, :format_percent)
  end

  def test_respond_find_records
    assert_respond_to(@dummy, :find_records)
  end

  def test_parse_file_returns_csv_object
    assert_instance_of CSV, @dummy.parse_file("./data/Special education.csv")
  end

  def test_format_percent_creates_float_and_rounds_to_3_decimals
    sample_num = 2.545195857435
    assert_instance_of Float, @dummy.format_percent(sample_num)
    assert_equal 2.545, @dummy.format_percent(sample_num)
  end

  def test_find_specific_records_returns_array_of_csv_objects
    contents = @dummy.parse_file("./data/Special education.csv")
    search = {search_in: "location", find:"Colorado"}
    records = @dummy.find_records(contents, search)
    assert_instance_of Array, records
    assert_equal 8, records.count
    records.each do |csv_obj|
      assert_instance_of CSV::Row, csv_obj
    end
  end
end

# def test_respond_to_csv_to_hash # Method unused as of iteration 0
#   assert_respond_to(@dummy, :csv_to_hash)
# end
# def test_get_column_returns_indiciated_column # unused as of iteration 0
#   skip
#   contents = @dummy.parse_file("./data/Special education.csv")
#   column = @dummy.get_column(contents, :location)
#   column = column[0].to_s
#
#   assert_includes "Colorado", column
# end
#
# def test_csv_to_hash_returns_array_of_hashes_of_data # unused as of iteration 0
#   skip
#   contents = @dummy.parse_file("./data/Special education.csv")
#   data = @dummy.csv_to_hash(contents)
#   assert_instance_of Array, @dummy.csv_to_hash(contents)
#   assert_equal 1086, @dummy.csv_to_hash(contents).count
#   data.each do |district_hash|
#     assert_instance_of Hash, district_hash
#   end
# end
