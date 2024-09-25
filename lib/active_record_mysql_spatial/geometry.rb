# frozen_string_literal: true

module ActiveRecordMysqlSpatial
  class Geometry
    class << self
      def parse_bin(bin)
        parser.parse(bin[4..])
      end

      def from_coordinates(coordinates, type: :linestring)
        send("#{type}_from_coords", coordinates)
      end

      def from_geometries(geometries)
        geometrycollection_from_geometries(geometries)
      end

      def from_text(value)
        cartesian_factory.parse_wkt(value)
      rescue StandardError
        nil
      end

      def valid_spatial?(value)
        point?(value) ||
          linestring?(value) ||
          multilinestring?(value) ||
          multipoint?(value) ||
          polygon?(value) ||
          multipolygon?(value) ||
          geometrycollection?(value)
      end

      def point?(value)
        /^point*.\(/i.match?(value)
      end

      def linestring?(value)
        /^linestring*.\(/i.match?(value)
      end

      def multilinestring?(value)
        /^multilinestring*.\(/i.match?(value)
      end

      def multipoint?(value)
        /^multipoint*.\(/i.match?(value)
      end

      def polygon?(value)
        /^polygon*.\(/i.match?(value)
      end

      def multipolygon?(value)
        /^multipolygon*.\(/i.match?(value)
      end

      def geometrycollection?(value)
        /^geometrycollection*.\(/i.match?(value)
      end

      private

      def point_from_coords(coordinate)
        x, y = if coordinate.is_a?(Array)
                 coordinate
               else
                 [
                   coordinate[:x] || coordinate['x'],
                   coordinate[:y] || coordinate['y']
                 ]
               end

        cartesian_factory.point(x, y)
      end

      def multipoint_from_coords(coordinates)
        points = coordinates.map do |coordinate|
          point_from_coords(coordinate)
        end

        cartesian_factory.multi_point(points)
      end

      def linestring_from_coords(coordinates)
        points = coordinates.map do |coordinate|
          point_from_coords(coordinate)
        end

        cartesian_factory.line_string(points)
      end

      def multilinestring_from_coords(coordinates)
        line_strings = coordinates.map do |coordinate|
          linestring_from_coords(coordinate)
        end

        cartesian_factory.multi_line_string(line_strings)
      end

      def polygon_from_coords(coordinates)
        outer_ring, *inner_rings = coordinates.map do |coordinate|
          linestring_from_coords(coordinate)
        end

        cartesian_factory.polygon(outer_ring, inner_rings)
      end

      def multipolygon_from_coords(coordinates)
        polygons = coordinates.map do |coordinate|
          polygon_from_coords(coordinate)
        end

        cartesian_factory.multi_polygon(polygons)
      end

      def geometrycollection_from_geometries(geometries)
        geos = geometries.map do |geometry|
          send("#{geometry[:type].downcase}_from_coords", geometry[:coordinates] || geometry[:coordinate])
        end

        cartesian_factory.collection(geos)
      end

      def parser
        @parser ||= RGeo::WKRep::WKBParser.new
      end

      def cartesian_factory
        @cartesian_factory ||= RGeo::Cartesian::Factory.new
      end
    end
  end
end
