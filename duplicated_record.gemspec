# encoding: utf-8

$:.push File.expand_path("../lib", __FILE__)
require "duplicated_record/version"

Gem::Specification.new do |s|
  s.name        = 'duplicated_record'
  s.version     = DuplicatedRecord::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Aurelien AMILIN']
  s.email       = ['aurelien.amilin@gmail.com']
  s.homepage    = 'https://github.com/holinnn/duplicated_resource'
  s.summary     = 'Merge duplicated records'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.licenses = ['MIT']

  s.add_development_dependency 'rails', ['>= 3.0.0']
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'spork'
  s.add_development_dependency 'database_cleaner'
end

