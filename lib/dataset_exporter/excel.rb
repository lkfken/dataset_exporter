require 'axlsx'
require 'pathname'

module DatasetExporter
  class Excel
    include DatasetExporter
    attr_reader :ds, :filename, :headers, :workbook, :package, :types

    def initialize(params={})
      @filename = params.fetch(:filename, 'default.xlsx')
      @ds       = params.fetch(:ds)
      @headers  = params.fetch(:headers, true) # true => include headers
      @types    = params.fetch(:types, _types) #type must be one of [:date, :time, :float, :integer, :string, :boolean, :iso_8601]
      @package  = Axlsx::Package.new
      @workbook = @package.workbook
      add_rows
    end

    def headings
      ds.first.values.keys
    end

    def rows
      ds.all
    end

    def to_str
      to_stream.read
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

    def _types
      ds_types.map do |type|
        case type
        when :bigdecimal
          :float
        when :fixnum
          :integer
        when :falseclass, :trueclass
          :boolean
        when :nilclass
          :string
        else
          type
        end
      end
    end

    def ds_types
      @ds.first.to_hash.values.map { |v| v.class.to_s.downcase.to_sym }
    end

    def add_rows
      workbook.add_worksheet do |sheet|
        sheet.add_row headings if headers
        rows.each do |row|
          sheet.add_row row.to_hash.values, :types => types
        end
      end
    end
  end
end