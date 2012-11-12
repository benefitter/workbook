require File.join(File.dirname(__FILE__), 'helper')
module Readers
  class TestXlsWriter < Test::Unit::TestCase
    def test_open
      w = Workbook::Book.new
      w.open 'test/artifacts/book_with_tabs_and_colours.xls'
      assert_equal([:a, :b, :c, :d, :e],w.sheet.table.header.to_symbols)
      assert_equal(90588,w.sheet.table[2][:b].value)
      assert_equal("#CCFFCC",w.sheet.table[3][:c].format[:background_color])
      assert_equal(8.13671875,w.sheet.table.first[:b].format[:width])
      assert_equal(3.85546875,w.sheet.table.first[:a].format[:width])
      assert_equal(25.14453125,w.sheet.table.first[:c].format[:width])
      
      
    end
    
    def test_complex_types
      w = Workbook::Book.new
      w.open 'test/artifacts/complex_types.xls'
      assert_equal(Date.new(2011,11,15), w.sheet.table[2][3].value)
      assert_equal("http://murb.nl", w.sheet.table[3][2].value)
      assert_equal("sadfasdfsd", w.sheet.table[4][2].value)
      assert_equal(1.2, w.sheet.table[3][1].value)
    end
    
    def test_excel_standardized_open
      w = Workbook::Book.new
      w.open("test/artifacts/excel_different_types.xls")
      # reads
      #   a,b,c,d
      # 2012-02-22,2014-12-27,2012-11-23,2012-11-12T04:20:00+00:00
      # c,222.0,,0027-12-14T05:21:00+00:00
      # 2012-01-22T11:00:00+00:00,42000.0,"goh, idd",ls
      
      assert_equal([:a,:b,:c, :d],w.sheet.table.header.to_symbols)
      assert_equal(Date.new(2012,2,22),w.sheet.table[1][:a].value)
      assert_equal("c",w.sheet.table[2][:a].value)
      assert_equal(DateTime.new(2012,1,22,11),w.sheet.table[3][:a].value)
      assert_equal(42000,w.sheet.table[3][:b].value)
      assert_equal(nil,w.sheet.table[2][:c].value)
    end
    
    def test_txt_in_xls_open
      w = Workbook::Book.new
      w.open("test/artifacts/txt_in_xls.xls")
      assert_equal([:naam,:nummer,:ilt,:corporate_key,:naam_medewerker, nil, nil, :telefoon, :openingsdatum],w.sheet.table.header.to_symbols)
      assert_equal(["dddd",2222,"i9000","asd","Anita",nil,"Betera",DateTime.new(2012,1,12),Date.new(2011,10,5)],w.sheet.table[1].collect{|a| a.value})
    end
    def test_zip_in_xls_open
      w = Workbook::Book.new
      failed_properly = false
      begin
        w.open("test/artifacts/zip_in_xls.xls")
        w.sheet.table.to_csv
      rescue Ole::Storage::FormatError
        failed_properly = true
      end
      assert_equal(true,failed_properly)
    end
    
  end
end