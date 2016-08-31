require 'rspec'
require_relative '../lib/dataset_exporter/csv'
require 'mhc_models'

describe DatasetExporter::CSV do
  it '#to_file' do
    senior_lobs = %w[250 253 256]
    ds = MhcModels::Member.active.cchp_members
             .exclude(:mem_lob => senior_lobs)
             .select_group(:mem_lob___lob,
                           :mem_no___member_id,
                           :ethnic_origin___ethnicity,
                           :primary_lang___language)

    exporter = DatasetExporter::CSV.new(ds: ds)

    exporter.to_file(:filename => 'file.txt', :col_sep => "\t")


  end
end