# frozen_string_literal: true

require 'active_support/concern'

require_relative 'mysql/linestring'
require_relative 'mysql/multilinestring'
require_relative 'mysql/point'

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module RegisterTypes
      extend ActiveSupport::Concern

      included do
        class_eval do
          class << self
            private

            def custom_initialize_type_map(type_map)
              type_map.register_type('point', MySQL::Point.new)
              type_map.register_type('linestring', MySQL::Linestring.new)
              type_map.register_type('multilinestring', MySQL::Multilinestring.new)
            end
          end

          remove_const('TYPE_MAP')
          const_set(
            'TYPE_MAP',
            ::ActiveRecord::Type::TypeMap.new.tap do |m|
              initialize_type_map(m)
              custom_initialize_type_map(m)
            end
          )
        end

        ::ActiveRecord::Type.register(:point, MySQL::Point, adapter: :mysql2)
        ::ActiveRecord::Type.register(:linestring, MySQL::Linestring, adapter: :mysql2)
        ::ActiveRecord::Type.register(:multilinestring, MySQL::Multilinestring, adapter: :mysql2)
      end
    end
  end
end