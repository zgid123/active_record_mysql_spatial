# frozen_string_literal: true

require 'active_support/concern'

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module ColumnMethods
      extend ActiveSupport::Concern

      included do
        define_column_methods :point,
                              :polygon,
                              :linestring,
                              :multipoint,
                              :multipolygon,
                              :geomcollection,
                              :multilinestring,
                              :geometrycollection
      end
    end
  end
end
