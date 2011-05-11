# encoding: utf-8

require 'active_support/concern'

module DuplicatedRecord
  module Orm
    module Base
      extend ActiveSupport::Concern

      included do
        class_attribute :_associations_to_merge
      end

      module ClassMethods
        private
        def merge_if_duplicate(*args)
          options = args.extract_options!
          associations = validate_associations_to_merge(args)

          self._associations_to_merge = associations
        end
      end

      module InstanceMethods
        def merge!(record)
          raise "record is not a #{self.class}" unless record.is_a?(self.class)

          self.class._associations_to_merge.each do |association|
            merge_association!(record, association)
          end
        end
      end
    end
  end
end
