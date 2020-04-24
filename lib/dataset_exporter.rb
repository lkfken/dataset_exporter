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
    first_row = ds.first
    case first_row
    when Hash
      first_row.keys
    else
      first_row.values.keys
    end
  end

  def rows
    ds.all
  end
end
