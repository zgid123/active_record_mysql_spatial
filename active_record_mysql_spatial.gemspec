# frozen_string_literal: true

require_relative 'lib/active_record_mysql_spatial/version'

Gem::Specification.new do |spec|
  spec.name = 'active_record_mysql_spatial'
  spec.version = ActiveRecordMysqlSpatial::VERSION
  spec.authors = ['Alpha']
  spec.email = ['alphanolucifer@gmail.com']

  spec.summary = 'MySQL Spatial Data Types for ActiveRecord'
  spec.description = 'MySQL Spatial Data Types for ActiveRecord'
  spec.homepage = 'https://github.com/zgid123/active_record_mysql_spatial'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(
          *%w[
            bin/
            test/
            spec/
            features/
            .git
            .circleci
            appveyor
            examples/
            Gemfile
            .rubocop.yml
            .vscode/settings.json
            LICENSE.txt
            lefthook.yml
          ]
        )
    end
  end

  spec.require_paths = ['lib']
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }

  spec.add_runtime_dependency 'rgeo', '~> 3.0', '>= 3.0.1'
end
