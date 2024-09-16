# frozen_string_literal: true

require_relative 'base'
require_relative 'polygon'

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module MySQL
      class Multipolygon < Base
        attr_accessor :items

        def type
          :multipolygon
        end

        def to_sql
          return nil if @items.blank?

          "MultiPolygon(#{to_coordinates_sql})"
        end

        def to_coordinates_sql
          items.map { |polygon| "(#{polygon.to_coordinates_sql})" }.join(',')
        end

        def ==(other)
          return false if super == false

          items.each_with_index do |item, index|
            return false if item != other.items[index]
          end

          true
        end

        private

        def cast_value(value)
          @raw = value
          coordinates, create_raw = extract_coordinates(value)

          @raw = Geometry.from_coordinates(coordinates, type: :multipolygon).as_binary if create_raw

          @items = coordinates.map do |polygon|
            Polygon.new.send(
              :cast_value,
              {
                coordinates: polygon
              }
            )
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
