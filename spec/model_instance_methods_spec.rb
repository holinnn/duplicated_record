# encoding: utf-8

require 'spec_helper'

describe DuplicatedRecord::Orm::Base::InstanceMethods do
  before(:each) do
    @publisher1 = Factory.create(:publisher)
    @publisher2 = Factory.create(:publisher)
  end

  describe "#merge!" do
    it "should raise an error if records or not from the same class" do
      expect {
        @publisher1.merge!(Book.first)
      }.to raise_error("record is not a Publisher")
    end
  end
end
