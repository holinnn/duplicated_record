require 'rails'

module DuplicatedResource
  class Railtie < ::Rails::Railtie
    initializer 'duplicated_resource' do |app|
      ActiveSupport.on_load(:active_record) do
        require File.join(File.dirname(__FILE__), 'orm/active_record')
        DuplicatedRecord::Orm::ActiveRecord.register_duplicated_record!
      end
    end
  end
end