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
end
