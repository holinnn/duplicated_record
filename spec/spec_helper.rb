require 'rubygems'
require 'bundler/setup'
require 'spork'

Spork.prefork do
  require 'active_record'
  require 'faker'
  require 'factory_girl'
  require 'rspec'
  require 'logger'
  require File.join(File.dirname(__FILE__), 'fixtures/factories')

  #require 'duplicated_record'

  require File.join(File.dirname(__FILE__), 'fixtures/active_record_models')

  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation

  ActiveRecord::Base.logger = Logger.new(STDOUT)

  RSpec.configure do |config|
    config.before :all do
      ModelsMigration.up unless ActiveRecord::Base.connection.table_exists?('books')
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each { |f| load f }

  load "#{File.dirname(__FILE__)}/fixtures/active_record_models.rb"
end

