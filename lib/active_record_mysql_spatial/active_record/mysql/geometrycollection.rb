# frozen_string_literal: true

require 'active_record_mysql_spatial/geometry'

require_relative 'base'
require_relative 'linestring'
require_relative 'multilinestring'
require_relative 'multipoint'
require_relative 'multipolygon'
require_relative 'point'
require_relative 'polygon'

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module MySQL
      class Geometrycollection < Base
        attr_accessor :items

        def type
          :geometrycollection
        end

        def to_sql
          return nil if @items.blank?

          "GeometryCollection(#{to_coordinates_sql})"
        end

        def to_coordinates_sql
          items.map(&:to_sql).compact.join(', ')
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
          elements, create_raw = extract_coordinates(value, type: :geometrycollection)

          @raw = Geometry.from_geometries(elements).as_binary if create_raw

          @items = elements.map do |geometry|
            klass, data = extract_data(geometry)

            klass.new.send(:cast_value, data)
          end

          self
        rescue StandardError => e
          handle_error(e)
        end

        def extract_data(geometry)
          if geometry.is_a?(Hash)
            extract_hash_data(geometry)
          else
            extract_cartesian_data(geometry)
          end
        end

        def extract_cartesian_data(geometry)
          case geometry.geometry_type
          when RGeo::Feature::Point
            [
              Point,
              {
                coordinates: geometry.coordinates
              }
            ]
          when RGeo::Feature::GeometryCollection
            [
              Geometrycollection,
              {
                geometries: geometry.geometries
              }
            ]
          when RGeo::Feature::LineString
            [
              Linestring,
              {
                coordinates: geometry.coordinates
              }
            ]
          when RGeo::Feature::MultiLineString
            [
              Multilinestring,
              {
                coordinates: geometry.coordinates
              }
            ]
          when RGeo::Feature::MultiPoint
            [
              Multipoint,
              {
                coordinates: geometry.coordinates
              }
            ]
          when RGeo::Feature::MultiPolygon
            [
              Multipolygon,
              {
                coordinates: geometry.coordinates
              }
            ]
          else
            [
              Polygon,
              {
                coordinates: geometry.coordinates
              }
            ]
          end
        end

        def extract_hash_data(geometry)
          type = geometry[:type].to_s.downcase
          klass = "ActiveRecordMysqlSpatial::ActiveRecord::MySQL::#{type.camelize}".constantize

          data = if type == 'geometrycollection'
                   {
                     geometries: geometry[:geometries] || geometry['geometries']
                   }
                 else
                   {
                     coordinates: geometry[:coordinates] || geometry['coordinates']
                   }
                 end

          [klass, data]
        end
      end
    end
  end
end
