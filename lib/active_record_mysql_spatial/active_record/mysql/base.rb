# frozen_string_literal: true

module ActiveRecordMysqlSpatial
  module ActiveRecord
    module MySQL
      class Base < ::ActiveRecord::Type::Json
        attr_reader :raw,
                    :error,
                    :error_backtrace

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

        def ==(other)
          self.class == other.class
        end

        private

        def handle_error(error)
          @error = error.message
          @error_backtrace = error.backtrace

          self
        end

        def cast_value(value)
          raise NotImplementedError
        end

        def extract_coordinates(attributes, type: :linestring)
          return [attributes, true] if type == :point && attributes.is_a?(Array)
          return [drill_coordinates(attributes, type: type) || [], true] if valid_hash?(attributes, type: type)
          return [[], false] unless attributes.is_a?(String)

          if attributes.encoding.to_s == 'ASCII-8BIT'
            spatial_data = Geometry.parse_bin(attributes)

            [drill_elements(spatial_data), false]
          elsif Geometry.valid_spatial?(attributes)
            spatial_data = Geometry.from_text(attributes)

            [drill_elements(spatial_data), true]
          else
            parsed_json = ::ActiveSupport::JSON.decode(attributes)

            coordinates = if type == :geometrycollection
                            parsed_json['geometries']
                          else
                            parsed_json['coordinates']
                          end

            [coordinates || [], true]
          end
        end

        def valid_hash?(attributes, type: :linestring)
          return false unless attributes.is_a?(Hash)
          return attributes.key?(:geometries) || attributes.key?('geometries') if type == :geometrycollection

          valid_coord_hash = attributes.key?(:coordinates) || attributes.key?('coordinates') || attributes.key?(:coordinate) || attributes.key?('coordinate')

          return valid_coord_hash unless type == :point

          valid_coord_hash || attributes.key?(:x) || attributes.key?('x') || attributes.key?(:y) || attributes.key?('y')
        end

        def drill_coordinates(attributes, type: :linestring)
          return attributes[:geometries].presence || attributes['geometries'] if type == :geometrycollection

          attributes[:coordinates].presence || attributes['coordinates'].presence || attributes[:coordinate].presence || attributes['coordinate']
        end

        def drill_elements(spatial)
          if spatial.geometry_type == RGeo::Feature::GeometryCollection
            spatial.geometries
          else
            spatial.coordinates
          end
        end
      end
    end
  end
end
