# frozen_string_literal: true

require_relative "../pathname_utility"

module JsDependency
  module SourceAnalysis
    # Components is not depended on.
    class Orphan
      def initialize(index, src_path)
        @index = index
        @src_path = src_path
      end

      def call
        orphan_index = @index.filter do |target_path, _child_paths|
          orphan?(target_path)
        end

        orphan_index = orphan_index.transform_keys do |target_path|
          relative_path_or_external_path(target_path, @src_path)
        end
        orphan_index.keys.uniq.sort
      end

      private

      def orphan?(target_path)
        target_pathname = JsDependency::TargetPathname.new(target_path)
        paths = []
        target_pathname.each_parent_path(1, @index) do |parent_path, _child_path|
          paths << parent_path
        end
        paths.size.zero?
      end

      def relative_path_or_external_path(path, src_path)
        JsDependency::PathnameUtility.relative_path_or_external_path(path, src_path)
      end
    end
  end
end
