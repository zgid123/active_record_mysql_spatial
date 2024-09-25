# frozen_string_literal: true

require 'rgeo'

require_relative 'active_record_mysql_spatial/active_record/column_methods'
require_relative 'active_record_mysql_spatial/active_record/mysql/geometrycollection'
require_relative 'active_record_mysql_spatial/active_record/mysql/linestring'
require_relative 'active_record_mysql_spatial/active_record/mysql/multilinestring'
require_relative 'active_record_mysql_spatial/active_record/mysql/multipoint'
require_relative 'active_record_mysql_spatial/active_record/mysql/multipolygon'
require_relative 'active_record_mysql_spatial/active_record/mysql/point'
require_relative 'active_record_mysql_spatial/active_record/mysql/polygon'
require_relative 'active_record_mysql_spatial/active_record/native_types'
require_relative 'active_record_mysql_spatial/active_record/quoting'
require_relative 'active_record_mysql_spatial/active_record/register_types'
require_relative 'active_record_mysql_spatial/acts_as_spatial'
require_relative 'active_record_mysql_spatial/geometry'
require_relative 'active_record_mysql_spatial/version'

module ActiveRecordMysqlSpatial
  class Error < StandardError; end

  class Railtie < Rails::Railtie
    initializer 'active_record.override_mysql_spatial' do
      ::ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.include ActiveRecordMysqlSpatial::ActiveRecord::Quoting
        ::ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.include ActiveRecordMysqlSpatial::ActiveRecord::NativeTypes

        ::ActiveRecord::ConnectionAdapters::Mysql2Adapter.include ActiveRecordMysqlSpatial::ActiveRecord::RegisterTypes

        ::ActiveRecord::ConnectionAdapters::MySQL::Table.include ActiveRecordMysqlSpatial::ActiveRecord::ColumnMethods

        ::ActiveRecord::ConnectionAdapters::MySQL::TableDefinition.include ActiveRecordMysqlSpatial::ActiveRecord::ColumnMethods
      end
    end
  end
end
