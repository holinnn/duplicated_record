# encoding: utf-8

require 'spec_helper'

describe DuplicatedRecord::Orm::Base::ClassMethods do
  before(:each) do
    @klass = Book
  end

  describe ".has_duplicates" do
    it "should set the associations to merge" do
      @klass.class_eval do
        merge_if_duplicate :jobs
      end

      @klass._associations_to_merge.should == [:jobs]
    end

    it "should raise en exception if an association does not exist" do
      expect {
      @klass.class_eval do
        merge_if_duplicate :jobs, :foo
      end
      }.to raise_error("foo association does not exist")
    end
  end
end
