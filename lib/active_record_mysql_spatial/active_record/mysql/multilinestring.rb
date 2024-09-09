# frozen_string_literal: true

require_relative 'base'
require_relative 'linestring'

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module MySQL
      class Multilinestring < Base
        attr_accessor :items

        def type
          :multilinestring
        end

        def to_sql
          return nil if @items.blank?

          "MultiLineString(#{to_coordinates_sql})"
        end

        def to_coordinates_sql
          items.map { |linestring| "(#{linestring.to_coordinates_sql})" }.join(',')
        end

        def ==(other)
          items.each_with_index do |item, index|
            return false if item != other.items[index]
          end

          true
        end

        private

        def cast_value(value)
          @raw = value
          coordinates, create_raw = extract_coordinates(value)

          @raw = Geometry.from_coordinates(coordinates, type: :multilinestring).as_binary if create_raw

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
          @error = e.message

          self
        end
      end
    end
  end
end