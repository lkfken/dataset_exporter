require 'csv'
require 'pathname'

module DatasetExporter
  class CSV
    attr_reader :ds, :filename
    def initialize(params={})
      @filename = params.fetch(:filename, 'default.txt')
      @ds = params.fetch(:ds)
    end

    def to_file(params={})
      filename = params.fetch(:filename, @filename)
      full_filename = File.absolute_path(filename)
      # create directories if needed
      Pathname.new(File.dirname(full_filename)).mkpath

      ::CSV.open(full_filename, 'wb') do |csv|
        first = true
        ds.all.each do |row|
          csv << row.to_enum.inject([]) { |r, n| r << n[0] } and first = false if first
          csv << row.to_enum.inject([]) { |r, n| r << n[1] }
        end
      end
    end

  end
end