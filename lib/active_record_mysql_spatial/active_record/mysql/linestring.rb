# frozen_string_literal: true

require_relative 'base'
require_relative 'point'

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module MySQL
      class Linestring < Base
        attr_reader :coordinates

        def type
          :linestring
        end

        def to_sql
          return nil if @coordinates.blank?

          "LineString(#{to_coordinates_sql})"
        end

        def to_coordinates_sql
          @coordinates.map(&:to_coordinate_sql).compact.join(', ')
        end

        def ==(other)
          coordinates.each_with_index do |coord, index|
            return false if coord != other.coordinates[index]
          end

          true
        end

        private

        def cast_value(value)
          @raw = value
          coordinates, create_raw = extract_coordinates(value)

          @raw = Geometry.from_coordinates(coordinates).as_binary if create_raw

          @coordinates = coordinates.map do |coord|
            Point.new.send(:cast_value, coord)
          end

          self
        rescue StandardError => e
          @error = e.message

          self
        end
      end
    end
  end
end
