# JsDependency

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/js_dependency`. To experiment with that code, run `bin/console` for an interactive prompt.

Analyze import dependency of JavaScript code and export mermaid format.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add js_dependency

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install js_dependency

## Usage
If your javascript code is in `./src` and `./src/App.vue` is in the directory, you can analyze `./src/App.vue` dependency like this:

```ruby
require 'js_dependency'


src_path = './src' # Root folder.
target_path = './src/App.vue' # Target file that you want to analyze.
child_analyze_level = 2 # Output level of child dependency.
parent_analyze_level = 2 # Output level of parent dependency.
output_path = './mermaid.txt' # Optional. Output file path
alias_paths = {'@' => '/src' } # Optional. Alias path.

# mermaid出力実行
JsDependency.export_mermaid(
  src_path,
  target_path,
  child_analyze_level: child_analyze_level,
  parent_analyze_level: parent_analyze_level,
  output_path: output_path,
  alias_paths: alias_paths)
```

See `./mermaid.txt` of `output_path` for the result.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/junara/js_dependency. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/js_dependency/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JsDependency project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/js_dependency/blob/main/CODE_OF_CONDUCT.md).
