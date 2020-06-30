require_relative 'dataset_exporter/version'
require_relative 'dataset_exporter/csv'
require_relative 'dataset_exporter/excel'

module DatasetExporter
  def db
    ds.db
  end

  def columns
    ds.columns
  end

  def headings
    @headings ||= begin
                    case
                    when first_row.is_a?(Hash)
                      first_row.keys
                    when first_row.kind_of?(Sequel::Model)
                      first_row.values.keys
                    else
                      raise "#{first_row.class} not defined"
                    end
                  end
  end

  def rows
    @rows ||= begin
                case
                when first_row.is_a?(Hash)
                  ds.all.map(&:values)
                when first_row.kind_of?(Sequel::Model)
                  ds.all.map(&:values).map(&:values)
                else
                  raise "#{first_row.class} not defined"
                end
              end
  end

  private

  def first_row
    @first_row ||= ds.first
  end
end
