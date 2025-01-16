require_relative "dataset_exporter/version"
require_relative "dataset_exporter/csv"
require_relative "dataset_exporter/excel"

module DatasetExporter
  class DatasetError < StandardError; end

  # @return an array of hashes
  def records
    @records ||= ds.naked.all
  end

  def columns
    @columns ||= ds.columns
  end

  def db
    @db ||= ds.db
  end

  def ds=(_ds_)
    @ds = _ds_
    @columns = _ds_.columns
    @records = _ds_.naked.all
  end
  
  alias_method :headings, :columns
  alias_method :headers, :columns

  def rows
    @rows ||= records.map { |hsh| hsh.values }
  end
end
