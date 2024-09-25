# frozen_string_literal: true

require_relative 'base'
require_relative 'linestring'

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module MySQL
      class Polygon < Base
        attr_accessor :items

        def type
          :polygon
        end

        def to_sql
          return nil if @items.blank?

          "Polygon(#{to_coordinates_sql})"
        end

        def to_coordinates_sql
          items.map { |linestring| "(#{linestring.to_coordinates_sql})" }.join(', ')
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

          @raw = Geometry.from_coordinates(coordinates, type: :polygon).as_binary if create_raw

          @items = coordinates.map do |linestring|
            Linestring.new.send(
              :cast_value,
              {
                coordinates: linestring
              }
            )
          end

          self
        rescue StandardError => e
          handle_error(e)
        end
      end
    end
  end
end
