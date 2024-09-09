# frozen_string_literal: true

require 'active_support/concern'

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module NativeTypes
      extend ActiveSupport::Concern

      included do
        class_eval do
          def native_database_types
            self.class.const_get('NATIVE_DATABASE_TYPES').merge(
              point: {
                name: 'point'
              },
              linestring: {
                name: 'linestring'
              },
              multilinestring: {
                name: 'multilinestring'
              }
            )
          end
        end
      end
    end
  end
end
