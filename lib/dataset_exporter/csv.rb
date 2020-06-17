require 'csv'
require 'pathname'

module DatasetExporter
  class CSV
    include DatasetExporter
    attr_reader :ds, :filename

    def initialize(ds:, filename: 'default.txt')
      @filename = filename
      @ds = ds
    end

    def rows
      @rows ||= ds.all.map(&:values).map(&:values)
    end

    def csv_table
      @csv_table ||= ::CSV::Table.new(csv_rows)
    end

    def csv_rows
      @csv_rows ||= rows.map { |row| ::CSV::Row.new(headings, row) }
    end

    def to_s(params = {})
      csv_table.to_csv(params)
    end

    def to_file(filename: filename)
      full_filename = File.absolute_path(filename)
      # create directories if needed
      Pathname.new(File.dirname(full_filename)).mkpath
      File.open(full_filename, 'wb') { |f| f.puts to_s(params) }
    end

  end
end