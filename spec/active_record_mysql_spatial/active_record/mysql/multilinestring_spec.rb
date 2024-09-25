# frozen_string_literal: true

require 'active_record'
require 'active_record_mysql_spatial/active_record/mysql/linestring'
require 'active_record_mysql_spatial/active_record/mysql/multilinestring'

describe ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Multilinestring do
  include_context :spatial_data

  context 'cast valid params' do
    %i[hash array].each do |type|
      context "params as #{type}" do
        subject { described_class.new.send(:cast_value, send("multilinestring#{type == :hash ? '' : '_array'}_params")) }

        it 'returns multilinestring' do
          expect(subject.type).to eq(:multilinestring)
          expect(subject.to_sql).to eq('MultiLineString((1 2, 2 3), (1 2, 2 3))')
          expect(subject.to_coordinates_sql).to eq('(1 2, 2 3), (1 2, 2 3)')
          expect(subject.error).to eq(nil)
          expect(subject.items).to eq(
            [
              ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Linestring.new.send(
                :cast_value,
                coordinates: [
                  [1, 2],
                  [2, 3]
                ]
              ),
              ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Linestring.new.send(
                :cast_value,
                coordinates: [
                  [1, 2],
                  [2, 3]
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
