require 'axlsx'
require 'pathname'

module DatasetExporter
  class Excel
    attr_reader :ds, :filename, :headers, :workbook, :package

    def initialize(params={})
      @filename = params.fetch(:filename, 'default.xlsx')
      @ds       = params.fetch(:ds)
      @headers  = params.fetch(:headers, true) # true => include headers
      @package  = Axlsx::Package.new
      @workbook = @package.workbook
      add_rows
    end

    def headings
      ds.columns
    end

    def rows
      ds.all
    end

    def to_stream
      package.to_stream
    end

    def to_file(params={})
      save_filename = params.fetch(:filename, filename)
      begin
        package.serialize(save_filename)
      rescue => ex
        File.delete(save_filename) if File.exist?(save_filename)
        raise ex
      end
    end

    private

    def add_rows
      workbook.add_worksheet do |sheet|
        sheet.add_row headings if headers
        rows.each do |row|
          sheet.add_row row.to_hash.values #, :types => :string
        end
      end
    end


  end
end