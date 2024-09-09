# frozen_string_literal: true

require_relative 'mysql/linestring'
require_relative 'mysql/multilinestring'
require_relative 'mysql/point'

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module Quoting
      def quote(value)
        case value
        when MySQL::Linestring, MySQL::Multilinestring, MySQL::Point
          quote_geom(value)
        else
          super
        end
      end

      private

      def quote_geom(value)
        spatial_raw = value.to_sql

        return 'NULL' if spatial_raw.blank?

        "ST_GeomFromText('#{spatial_raw}')"
      end
    end
  end
end
