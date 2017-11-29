source "https://rubygems.org"

puppetversion = ENV['PUPPET_VERSION']

group :test do
  gem "rake", '< 11.0'
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 3.8.0'
  gem "rspec", '< 3.2.0'
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "puppetlabs_spec_helper", '< 1.2.0'
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
  gem 'rubocop', '0.33.0'
  gem 'simplecov', '>= 0.11.0'
  gem 'simplecov-console'

  gem "puppet-lint-absolute_classname-check"
  gem "puppet-lint-leading_zero-check"
  gem "puppet-lint-trailing_comma-check"
  gem "puppet-lint-version_comparison-check"
  gem "puppet-lint-classes_and_types_beginning_with_digits-check"
  gem "puppet-lint-unquoted_string-check"
  gem 'puppet-lint-resource_reference_syntax'

  if Gem::Version.new(puppetversion) < Gem::Version.new('4.9')
    gem 'semantic_puppet', '1.0.1',                               :require => false
  end

  gem 'json_pure', '<= 2.0.1' if RUBY_VERSION < '2.0.0'
end

group :development do
  gem "travis"                if RUBY_VERSION >= '2.1.0'
  gem "travis-lint"           if RUBY_VERSION >= '2.1.0'
  gem "puppet-blacksmith"
  gem "guard-rake"            if RUBY_VERSION >= '2.2.5'
end

group :system_tests do
  gem "beaker"
  gem "beaker-rspec"
  gem "beaker-puppet_install_helper", '<= 0.6.0'
end
