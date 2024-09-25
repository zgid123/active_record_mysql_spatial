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
              polygon: {
                name: 'polygon'
              },
              linestring: {
                name: 'linestring'
              },
              multipoint: {
                name: 'multipoint'
              },
              multipolygon: {
                name: 'multipolygon'
              },
              multilinestring: {
                name: 'multilinestring'
              },
              geomcollection: {
                name: 'geomcollection'
              },
              geometrycollection: {
                name: 'geometrycollection'
              }
            )
          end
        end
      end
    end
  end
end
