# Managed by modulesync - DO NOT EDIT
# https://voxpupuli.org/docs/updating-files-managed-with-modulesync/

source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :development do
  gem 'github_changelog_generator', '~> 1.15',                                :require => false
  gem 'puppet-lint-absolute_classname-check', '~> 3.0',                       :require => false
  gem 'puppet-lint-absolute_template_path', '~> 1.0',                         :require => false
  gem 'puppet-lint-anchor-check', '~> 1.0',                                   :require => false
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check', '~> 0.1',  :require => false
  gem 'puppet-lint-empty_string-check', '~> 0.2',                             :require => false
  gem 'puppet-lint-file_ensure-check', '~> 0.3',                              :require => false
  gem 'puppet-lint-leading_zero-check', '~> 0.1',                             :require => false
  gem 'puppet-lint-legacy_facts-check', '~> 1.0',                             :require => false
  gem 'puppet-lint-manifest_whitespace-check', '~> 0.1',                      :require => false
  gem 'puppet-lint-param-docs', '~> 1.6',                                     :require => false
  gem 'puppet-lint-resource_reference_syntax', '~> 1.0',                      :require => false
  gem 'puppet-lint-spaceship_operator_without_tag-check', '~> 0.1',           :require => false
  gem 'puppet-lint-strict_indent-check', '~> 2.0',                            :require => false
  gem 'puppet-lint-top_scope_facts-check', '~> 1.0',                          :require => false
  gem 'puppet-lint-topscope-variable-check', '~> 1.0',                        :require => false
  gem 'puppet-lint-trailing_comma-check', '~> 0.4',                           :require => false
  gem 'puppet-lint-trailing_newline-check', '~> 1.1',                         :require => false
  gem 'puppet-lint-undef_in_function-check', '~> 0.2',                        :require => false
  gem 'puppet-lint-unquoted_string-check', '~> 2.0',                          :require => false
  gem 'puppet-lint-variable_contains_upcase', '~> 1.2',                       :require => false
  gem 'puppet-lint-version_comparison-check', '~> 0.2',                       :require => false
end

gem 'rake', :require => false
gem 'facter', ENV['FACTER_GEM_VERSION'], :require => false, :groups => [:test]

puppetversion = ENV['PUPPET_GEM_VERSION'] || [">= 7.24", "< 9"]
gem 'puppet', puppetversion, :require => false, :groups => [:test]

# vim: syntax=ruby
