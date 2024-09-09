# frozen_string_literal: true

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module MySQL
      class Base < ::ActiveRecord::Type::Json
        attr_reader :raw,
                    :error

        def type
          raise NotImplementedError
        end

        def deserialize(value)
          return value if value.is_a?(self.class)

          cast_value(value)
        end

        def serialize(value)
          if value.is_a?(self.class)
            value
          else
            return unless valid_hash?(value)

            cast_value(value)
          end
        end

        def to_sql
          raise NotImplementedError
        end

        def to_coordinates_sql
          raise NotImplementedError
        end

        private

        def cast_value(value)
          raise NotImplementedError
        end

        def extract_coordinates(attributes, type: :linestring)
          return [drill_coordinates(attributes) || [], true] if valid_hash?(attributes, type: type)
          return [[], false] unless attributes.is_a?(String)

          if attributes.encoding.to_s == 'ASCII-8BIT'
            linestring = Geometry.parse_bin(attributes)

            [linestring.coordinates, false]
          elsif Geometry.valid_spatial?(attributes)
            spatial_data = Geometry.from_text(attributes)

            [spatial_data.coordinates, true]
          else
            parsed_json = ::ActiveSupport::JSON.decode(attributes)

            [parsed_json['coordinates'] || [], true]
          end
        end

        def valid_hash?(attributes, type: :linestring)
          return false unless attributes.is_a?(Hash)

          valid_coord_hash = attributes.key?(:coordinates) || attributes.key?('coordinates') || attributes.key?(:coordinate) || attributes.key?('coordinate')

          return valid_coord_hash unless type == :point

          valid_coord_hash || attributes.key?(:x) || attributes.key?('x') || attributes.key?(:y) || attributes.key?('y')
        end

        def drill_coordinates(attributes)
          attributes[:coordinates].presence || attributes['coordinates'].presence || attributes[:coordinate].presence || attributes['coordinate']
        end
      end
    end
  end
end
