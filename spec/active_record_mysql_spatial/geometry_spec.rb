# frozen_string_literal: true

require 'active_record_mysql_spatial/geometry'

describe ActiveRecordMysqlSpatial::Geometry do
  include_context :spatial_data

  subject { described_class }

  describe '#parse_bin' do
    %i[point linestring multilinestring multipoint polygon multipolygon geometrycollection].each do |type|
      context "parse #{type} from binary text" do
        it "returns #{type}" do
          rgeo_data = subject.parse_bin(send("raw_#{type}"))

          expect(rgeo_data.to_s).to eq(send("sql_#{type}"))
          expect(rgeo_data.geometry_type).to eq(send("#{type}_geometry_type"))
        end
      end
    end
  end

  describe '#from_coordinates' do
    %i[point linestring multilinestring multipoint polygon multipolygon].each do |type|
      context "parse #{type} from coordinates" do
        it "returns #{type}" do
          data = if type == :point
                   send("#{type}_params")
                 else
                   send("#{type}_params")[:coordinates]
                 end

          rgeo_data = subject.from_coordinates(data, type: type)

          expect(rgeo_data.to_s).to eq(send("sql_#{type}"))
          expect(rgeo_data.geometry_type).to eq(send("#{type}_geometry_type"))
        end
      end
    end
  end

  describe '#from_geometries' do
    %i[geometrycollection].each do |type|
      context "parse #{type} from geometries" do
        it "returns #{type}" do
          data = send("#{type}_params")[:geometries]

          rgeo_data = subject.from_geometries(data)

          expect(rgeo_data.to_s).to eq(send("sql_#{type}"))
          expect(rgeo_data.geometry_type).to eq(send("#{type}_geometry_type"))
        end
      end
    end
  end

  describe '#from_text' do
    %i[point linestring multilinestring multipoint polygon multipolygon geometrycollection].each do |type|
      context "parse #{type} from sql value" do
        it "returns #{type}" do
          sql_data = send("sql_#{type}")
          rgeo_data = subject.from_text(sql_data)

          expect(rgeo_data.to_s).to eq(sql_data)
          expect(rgeo_data.geometry_type).to eq(send("#{type}_geometry_type"))
        end
      end
    end
  end

  describe '#valid_spatial?' do
    context 'valid spatial'  do
      %i[point linestring multilinestring multipoint polygon multipolygon geometrycollection].each do |type|
        it "returns true for #{type}" do
          sql_data = send("sql_#{type}")

          expect(subject.valid_spatial?(sql_data)).to be(true)
          expect(subject.valid_spatial?(sql_data.downcase)).to be(true)
        end
      end
    end

    context 'invalid spatial' do
      it 'returns false' do
        expect(subject.valid_spatial?('foo')).to be(false)
      end
    end
  end

  %i[point linestring multilinestring multipoint polygon multipolygon geometrycollection].each do |type|
    describe "##{type}?" do
      context "is #{type}" do
        it 'returns true' do
          expect(subject.send("#{type}?", send("sql_#{type}"))).to be(true)
        end
      end

      context "is not #{type}" do
        it 'returns false' do
          expect(subject.send("#{type}?", 'foo')).to be(false)
        end
      end
    end
  end
end
