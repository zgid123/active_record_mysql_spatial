# frozen_string_literal: true

require_relative 'base'
require_relative 'point'

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module MySQL
      class Multipoint < Base
        attr_reader :items

        def type
          :multipoint
        end

        def to_sql
          return nil if @items.blank?

          "MultiPoint(#{to_coordinates_sql})"
        end

        def to_coordinates_sql
          @items.map(&:to_coordinate_sql).compact.join(', ')
        end

        def ==(other)
          return false if super == false

          items.each_with_index do |coord, index|
            return false if coord != other.items[index]
          end

          true
        end

        private

        def cast_value(value)
          @raw = value
          coordinates, create_raw = extract_coordinates(value)

          @raw = Geometry.from_coordinates(coordinates, type: :multipoint).as_binary if create_raw

          @items = coordinates.map do |coord|
            Point.new.send(:cast_value, coord)
          end

          self
        rescue StandardError => e
          handle_error(e)
        end
      end
    end
  end
end
