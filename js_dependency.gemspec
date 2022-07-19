# frozen_string_literal: true

require_relative "lib/js_dependency/version"

Gem::Specification.new do |spec|
  spec.name = "js_dependency"
  spec.version = JsDependency::VERSION
  spec.authors = ["junara"]
  spec.email = ["jun5araki@gmail.com"]

  spec.summary = "Analyze dependency using import for JavaScript."
  spec.description = spec.summary.to_s
  spec.homepage = "https://github.com/junara/#{spec.name}"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://rubydoc.info/gems/#{spec.name}"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pathname"
  spec.add_dependency "thor"
  spec.add_dependency "yaml"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-parameterized"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-rspec"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
