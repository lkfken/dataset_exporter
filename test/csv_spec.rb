require 'rspec'
require_relative '../lib/dataset_exporter/csv'

describe DatasetExporter::CSV do

  it '#to_file' do
    exporter = DatasetExporter::CSV.new(ds: MhcModels::Member.where(:last_name => 'LEUNG').where(Sequel.like(:first_name, 'KIN%')))
    exporter.to_file(:filename => 'file.txt')
  end
end