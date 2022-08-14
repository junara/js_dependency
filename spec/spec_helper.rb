# frozen_string_literal: true

require "debug"
require "rspec-parameterized"

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
  enable_coverage :branch
  primary_coverage :branch
end

if ENV["CI"] == "true"
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require "js_dependency"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # rubocop:disable Security/Eval, Style/DocumentDynamicEvalDefinition, Style/EvalWithLocation

  # capture command line standard output
  # @see https://github.com/rails/thor/blob/e4907fdd663d0a1ff51d18eb1827552ee61300a3/spec/helper.rb#L51-L62
  # @param [Symbol] stream
  # @return [String]
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
  # rubocop:enable Security/Eval, Style/DocumentDynamicEvalDefinition, Style/EvalWithLocation
end
