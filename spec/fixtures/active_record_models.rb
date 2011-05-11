# encoding: utf-8

require 'active_record'
require 'duplicated_record/orm/active_record'

DuplicatedRecord::Orm::ActiveRecord.register_duplicated_record!

# Database
ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('test')


# Migration
class ModelsMigration < ActiveRecord::Migration
  def self.up
    create_table(:books) { |t| t.string :title; t.integer :publisher_id }
    create_table(:publishers) { |t| t.string :name; t.integer :books_count }
    create_table(:jobs) { |t| t.integer :book_id; t.integer :author_id; t.string :title  }
    create_table(:author) { |t| t.string :name }
  end
end

# Models
class Book < ActiveRecord::Base
  belongs_to :publisher, :counter_cache => true
  has_many :jobs
  has_many :authors, :through => :jobs

  before_update :change_title

  private
  def change_title
    self.title = "callback called"
  end
end

class Author < ActiveRecord::Base
  has_many :jobs
  has_many :books, :through => :jobs
end

class Publisher < ActiveRecord::Base
  has_many :books
  merge_if_duplicate :books
end

class Job < ActiveRecord::Base
  belongs_to :author
  belongs_to :book
end