# frozen_string_literal: true

require_relative "../pathname_utility"
module JsDependency
  module SourceAnalysis
    # Components have no dependencies.
    class Leave
      # @param [Hash] index
      # @param [String] src_path
      def initialize(index, src_path)
        @index = index
        @src_path = src_path
      end

      # @return [Array<String>]
      def call
        left_index = @index.filter do |_target_path, child_paths|
          blank?(child_paths)
        end

        left_index = left_index.transform_keys do |target_path|
          relative_path_or_external_path(target_path, @src_path)
        end
        left_index.keys.uniq.sort
      end

      private

      # @param [Array<String>] paths
      # @return [TrueClass, FalseClass]
      def blank?(paths)
        paths.nil? || paths.empty?
      end

      # @param [String] path
      # @param [String] src_path
      # @return [String]
      def relative_path_or_external_path(path, src_path)
        JsDependency::PathnameUtility.relative_path_or_external_path(path, src_path)
      end
    end
  end
end
