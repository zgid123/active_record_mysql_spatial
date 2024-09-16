# frozen_string_literal: true

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module MySQL
      class Point < Base
        attr_reader :x,
                    :y

        def type
          :point
        end

        def serialize(value)
          if value.is_a?(Point)
            value
          else
            return unless valid_hash?(value, type: :point)

            cast_value(value)
          end
        end

        def to_sql
          return nil if @x.nil? || @y.nil?

          "Point(#{to_coordinate_sql})"
        end

        def to_coordinate_sql
          return nil if @x.nil? || @y.nil?

          "#{@x} #{@y}"
        end

        alias to_coordinates_sql to_coordinate_sql

        def ==(other)
          super && x == other.x && y == other.y
        end

        private

        def cast_value(value)
          @raw = value
          coordinate, create_raw = extract_coordinates(value, type: :point)

          @raw = Geometry.from_coordinates(coordinate, type: :point).as_binary if create_raw

          @x, @y = if coordinate.is_a?(Array) && coordinate.present?
                     [coordinate[0], coordinate[1]]
                   elsif value.is_a?(Array)
                     [value[0], value[1]]
                   elsif value.is_a?(Hash)
                     [value[:x] || value['x'], value[:y] || value['y']]
                   else
                     [nil, nil]
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
