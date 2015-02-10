# DatasetExporter

Save the dataset to a file

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dataset_exporter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dataset_exporter

## Usage

DatasetExporter::CSV.new(ds: dataset).to_file(:filename => 'output/csv.txt')

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dataset_exporter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
