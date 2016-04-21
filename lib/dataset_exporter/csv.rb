require 'csv'
require 'pathname'

module DatasetExporter
  class CSV
    attr_reader :ds, :filename

    def initialize(params={})
      @filename = params.fetch(:filename, 'default.txt')
      @ds = params.fetch(:ds)
      @csv_options = params.fetch(:csv_options, Hash.new)
    end

    def rows
      @rows ||= ds.all
    end

    def to_s(params={})
      ::CSV.generate(@csv_options.merge(params)) do |csv|
        first = true
        rows.each do |row|
          csv << row.to_enum.inject([]) { |r, n| r << n[0] } and first = false if first
          csv << row.to_enum.inject([]) { |r, n| r << n[1] }
        end
      end
    end

    def to_file(params={})
      filename = params.fetch(:filename, @filename)
      params = params.delete_if { |k, v| k == :filename }
      full_filename = File.absolute_path(filename)
      # create directories if needed
      Pathname.new(File.dirname(full_filename)).mkpath

      File.open(full_filename, 'wb') do |f|
        f.puts to_s(params)
      end
    end

  end
end