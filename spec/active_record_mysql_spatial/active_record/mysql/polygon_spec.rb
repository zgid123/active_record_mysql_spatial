# frozen_string_literal: true

require 'active_record'
require 'active_record_mysql_spatial/active_record/mysql/linestring'
require 'active_record_mysql_spatial/active_record/mysql/polygon'

describe ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Polygon do
  include_context :spatial_data

  context 'cast valid params' do
    %i[hash array].each do |type|
      context "params as #{type}" do
        subject { described_class.new.send(:cast_value, send("polygon#{type == :hash ? '' : '_array'}_params")) }

        it 'returns polygon' do
          expect(subject.type).to eq(:polygon)
          expect(subject.to_sql).to eq('Polygon((0.0 0.0, 10.0 0.0, 10.0 10.0, 0.0 10.0, 0.0 0.0), (5.0 5.0, 7.0 5.0, 7.0 7.0, 5.0 7.0, 5.0 5.0))')
          expect(subject.to_coordinates_sql).to eq('(0.0 0.0, 10.0 0.0, 10.0 10.0, 0.0 10.0, 0.0 0.0), (5.0 5.0, 7.0 5.0, 7.0 7.0, 5.0 7.0, 5.0 5.0)')
          expect(subject.error).to eq(nil)
          expect(subject.items).to eq(
            [
              ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Linestring.new.send(
                :cast_value,
                coordinates: [
                  { x: 0.0, y: 0.0 },
                  { x: 10.0, y: 0.0 },
                  { x: 10.0, y: 10.0 },
                  { x: 0.0, y: 10.0 },
                  { x: 0.0, y: 0.0 }
                ]
              ),
              ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Linestring.new.send(
                :cast_value,
                coordinates: [
                  { x: 5.0, y: 5.0 },
                  { x: 7.0, y: 5.0 },
                  { x: 7.0, y: 7.0 },
                  { x: 5.0, y: 7.0 },
                  { x: 5.0, y: 5.0 }
                ]
              )
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
