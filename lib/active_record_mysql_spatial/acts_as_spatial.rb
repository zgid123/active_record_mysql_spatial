# frozen_string_literal: true

require 'active_support/concern'

module ActiveRecordMysqlSpatial
  module ActsAsSpatial
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_linestring(*columns, serializer: nil)
        return if serializer.blank?

        columns.each do |col|
          attribute(col, serializer.new)
        end
      end

      alias_method :acts_as_point, :acts_as_linestring
      alias_method :acts_as_multilinestring, :acts_as_linestring
    end
  end
end
