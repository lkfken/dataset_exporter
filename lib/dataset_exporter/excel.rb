require 'axlsx'
require 'pathname'

module DatasetExporter
  class Excel
    include DatasetExporter
    attr_reader :filename, :headers, :package, :sheets

    # sheets = {name[String]: dataset[Sequel::Dataset]}
    def initialize(sheets: {}, filename: 'default.xlsx', headers: true,
                   package: Axlsx::Package.new)
      @filename = filename
      @sheets = sheets
      @headers = headers
      @package = package

      add_sheets
    end

    def workbook
      @workbook ||= package.workbook
    end

    def to_str
      to_stream.string.force_encoding(Encoding::ASCII_8BIT)
    end

    def to_stream
      package.to_stream
    end

    def to_file(filename: self.filename)
      package.serialize(filename)
    rescue StandardError => e
      File.delete(filename) if File.exist?(filename)
      raise e
    end

    private

    def try_convert_types(types)
      types.map do |type|
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

    def add_sheets
      sheets.each do |name, ds|
        raise DatasetError, ['@ds has no records!', ds.inspect].join($/) if ds.empty?
        records = ds.naked
        headings = records.first.keys
        rows = records.map { |hsh| hsh.values }
            
        workbook.add_worksheet(name: name.to_s) do |sheet|
          sheet.add_row headings if headers
          types = try_convert_types(ds.first.to_hash.values.map { |v| v.class.to_s.downcase.to_sym })
          rows.each { |row| sheet.add_row row, types: types}
        end
      end
    end
  end
end
