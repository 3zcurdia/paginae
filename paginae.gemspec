# frozen_string_literal: true

require_relative "lib/paginae/version"

Gem::Specification.new do |spec|
  spec.name = "paginae"
  spec.version = Paginae::VERSION
  spec.authors = ["Luis Ezcurdia"]
  spec.email = ["ing.ezcurdia@gmail.com"]

  spec.summary = "Simple page objects for Ruby"
  spec.description = "DSL for page objects in Ruby"
  spec.homepage = "https://github.com/3zcurdia/paginae"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/3zcurdia/paginae/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", ">= 1.13.4"

  spec.metadata["rubygems_mfa_required"] = "true"
end
