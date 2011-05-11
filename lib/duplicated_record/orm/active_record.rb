# encoding: utf-8

module DuplicatedRecord
  module Orm
    module ActiveRecord
      extend ActiveSupport::Concern
      include Base

      def self.register_duplicated_record!
        ::ActiveRecord::Base.class_eval do
          include DuplicatedRecord::Orm::ActiveRecord
        end
      end

      module ClassMethods
        private
        def validate_associations_to_merge(associations)
          existing_association_names = reflections.keys

          associations.each do |association|
            raise "#{association} association does not exist" unless existing_association_names.include?(association)
            through = reflect_on_association(association).options[:through] and
                raise "#{association} is a has_many :through association you should only merge the #{through} association"

          end
          associations
        end
      end

      module InstanceMethods
        include Base::InstanceMethods
        def merge_association!(record, association_name)
          reflection = self.class.reflect_on_association(association_name)
          case reflection.macro
            when :has_many
              merge_has_many_association(record, reflection)
          end
        end

        private
        def merge_has_many_association(record, reflection)
          association_name = reflection.name

          record.send(reflection.name).each do |resource|
            self.send(association_name) << resource
          end

          self.class.reset_counters(self.id, reflection.name) if counter_cache_name(reflection)
        end

        # From counter_cache.rb
        def counter_cache_name(reflection)
          expected_name = if reflection.options[:as]
            reflection.options[:as].to_s.classify
          else
            self.class.name
          end
          child_class  = reflection.klass
          belongs_to   = child_class.reflect_on_all_associations(:belongs_to)
          child_reflection   = belongs_to.find { |e| e.class_name == expected_name }
          child_reflection.counter_cache_column
        end
      end
    end
  end
end