require_relative 'dataset_exporter/version'
require_relative 'dataset_exporter/csv'
require_relative 'dataset_exporter/excel'

module DatasetExporter
  def db
    ds.db
  end

  # @return an array of hashes
  def records
    @records ||= ds.naked
  end

  def columns
    @columns ||= records.first.keys
  end

  alias_method :headings, :columns

  # def headings
  #   @headings ||= begin
  #                   case
  #                   when first_row.is_a?(Hash)
  #                     first_row.keys
  #                   when first_row.kind_of?(Sequel::Model)
  #                     first_row.values.keys
  #                   else
  #                     raise "#{first_row.class} not defined"
  #                   end
  #                 end
  # end

  def rows
    @rows ||= records.map { |hsh| hsh.values }
  end
end
