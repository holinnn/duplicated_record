# encoding: utf-8

require 'spec_helper'

describe DuplicatedRecord::Orm::ActiveRecord do
  describe "ClassMethods" do
    before(:each) do
      @klass = Book
    end

    describe ".validate_associations_to_merge" do
      it "should raise en exception if an association does not exist" do
        expect {
        @klass.class_eval do
          merge_if_duplicate :jobs, :foo
        end
        }.to raise_error("foo association does not exist")
      end

      it "should raise an exception for has many through associations" do
        expect {
        @klass.class_eval do
          merge_if_duplicate :authors
        end
        }.to raise_error("authors is a has_many :through association you should only merge the jobs association")
      end
    end
  end

  describe "InstanceMethods" do
    before(:each) do
      # Create 2 publisher with 5 books each and reload them
      2.times do |i|
        variable_name = "@publisher#{i+1}".to_sym
        instance_variable_set variable_name, Factory.create(:publisher)
        5.times { Factory.create(:book, :publisher =>  instance_variable_get(variable_name)) }
        instance_variable_get(variable_name).reload
      end
    end

    describe "#merge_has_many_association" do
      it "should update foreign key of associated resources and trigger callbacks" do
        expect {
          @publisher1.merge!(@publisher2)
          @publisher1.reload
        }.to change { @publisher1.books_count }.from(5).to(10)


        @publisher2.books.count.should == 0
        Book.where(:title => "callback called").count.should == 5
        Book.all.each do |book|
          book.publisher.should == @publisher1
        end
      end
    end
  end
end
