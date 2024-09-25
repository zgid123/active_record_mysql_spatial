# frozen_string_literal: true

require 'active_record'
require 'active_record_mysql_spatial/active_record/mysql/geometrycollection'
require 'active_record_mysql_spatial/active_record/mysql/linestring'
require 'active_record_mysql_spatial/active_record/mysql/multilinestring'
require 'active_record_mysql_spatial/active_record/mysql/multipoint'
require 'active_record_mysql_spatial/active_record/mysql/multipolygon'
require 'active_record_mysql_spatial/active_record/mysql/point'
require 'active_record_mysql_spatial/active_record/mysql/polygon'

sql_string = [
  'Point(1 2)',
  'LineString(1 2, 2 3)',
  'MultiLineString((1 2, 2 3), (1 2, 2 3))',
  'MultiPoint(1 2, 2 3)',
  'Polygon((0.0 0.0, 10.0 0.0, 10.0 10.0, 0.0 10.0, 0.0 0.0), (5.0 5.0, 7.0 5.0, 7.0 7.0, 5.0 7.0, 5.0 5.0))',
  'MultiPolygon(((0.0 0.0, 10.0 0.0, 10.0 10.0, 0.0 10.0, 0.0 0.0)), ((5.0 5.0, 7.0 5.0, 7.0 7.0, 5.0 7.0, 5.0 5.0)))'
].join(', ')

describe ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Geometrycollection do
  include_context :spatial_data

  context 'cast valid params' do
    %i[hash array].each do |type|
      context "params as #{type}" do
        subject { described_class.new.send(:cast_value, send("geometrycollection#{type == :hash ? '' : '_array'}_params")) }

        it 'returns geometrycollection' do
          expect(subject.type).to eq(:geometrycollection)
          expect(subject.to_sql).to eq("GeometryCollection(#{sql_string})")
          expect(subject.to_coordinates_sql).to eq(sql_string)
          expect(subject.error).to eq(nil)
          expect(subject.items).to eq(
            [
              ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Point.new.send(:cast_value, point_params),
              ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Linestring.new.send(:cast_value, linestring_params),
              ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Multilinestring.new.send(:cast_value, multilinestring_params),
              ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Multipoint.new.send(:cast_value, multipoint_params),
              ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Polygon.new.send(:cast_value, polygon_params),
              ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Multipolygon.new.send(:cast_value, multipolygon_params)
            ]
          )
        end
      end
    end
  end

  context 'cast invalid params' do
    subject { described_class.new.send(:cast_value, { a: 1, b: 2 }) }

    it 'has empty items' do
      expect(subject.items).to eq([])
    end
  end
end
