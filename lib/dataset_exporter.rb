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
    @columns ||= records.first.keys
  end

  alias_method :headings, :columns
  alias_method :headers, :columns

  def rows
    @rows ||= records.map { |hsh| hsh.values }
  end
end
