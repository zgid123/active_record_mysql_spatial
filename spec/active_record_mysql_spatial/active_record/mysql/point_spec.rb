# frozen_string_literal: true

require 'active_record'
require 'active_record_mysql_spatial/active_record/mysql/point'

describe ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Point do
  include_context :spatial_data

  context 'cast valid params' do
    %i[hash array].each do |type|
      context "params as #{type}" do
        subject { described_class.new.send(:cast_value, send("point#{type == :hash ? '' : '_array'}_params")) }

        it 'returns point' do
          expect(subject.type).to eq(:point)
          expect(subject.to_sql).to eq('Point(1 2)')
          expect(subject.to_coordinate_sql).to eq('1 2')
          expect(subject.error).to eq(nil)
          expect(subject.x).to eq(1)
          expect(subject.y).to eq(2)
        end
      end
    end
  end

  context 'cast invalid params' do
    subject { described_class.new.send(:cast_value, { a: 1, b: 2 }) }

    it 'has empty x and y' do
      expect(subject.x).to eq(nil)
      expect(subject.y).to eq(nil)
    end
  end
end
