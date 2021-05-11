require "axlsx"
require "pathname"

module DatasetExporter
  class Excel
    include DatasetExporter
    attr_reader :ds, :filename, :headers, :workbook, :package, :types

    def initialize(params = {})
      @filename = params.fetch(:filename, "default.xlsx")
      @ds = params.fetch(:ds)
      @headers = params.fetch(:headers, true) # true => include headers
      @types = params.fetch(:types, _types) #type must be one of [:date, :time, :float, :integer, :string, :boolean, :iso_8601]
      @package = Axlsx::Package.new
      @workbook = @package.workbook
      raise DatasetError, ["@ds has no records!", @ds.inspect].join($/) if @ds.empty?
      add_rows
    end

    def to_str
      to_stream.string.force_encoding(Encoding::ASCII_8BIT)
    end

    def to_stream
      package.to_stream
    end

    def to_file(filename: self.filename)
      begin
        package.serialize(filename)
      rescue => ex
        File.delete(filename) if File.exist?(filename)
        raise ex
      end
    end

    private

    def _types
      ds_types.map do |type|
        case type
        when :bigdecimal, :float
          :float
        when :fixnum, :integer
          :integer
        when :falseclass, :trueclass
          :boolean
        when :nilclass, :string
          :string
        when :date
          :date
        when :time
          :time
        else
          raise "#{type} not defined"
        end
      end
    end

    def ds_types
      @ds.first.to_hash.values.map { |v| v.class.to_s.downcase.to_sym }
    end

    def add_rows
      workbook.add_worksheet do |sheet|
        sheet.add_row headings if headers
        rows.each { |row| sheet.add_row row, :types => types }
      end
    end
  end
end
