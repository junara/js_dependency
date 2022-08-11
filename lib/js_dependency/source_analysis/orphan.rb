# frozen_string_literal: true

require_relative "../pathname_utility"

module JsDependency
  module SourceAnalysis
    # Components is not depended on.
    class Orphan
      # @param [Hash] index
      # @param [String] src_path
      def initialize(index, src_path)
        @index = index
        @src_path = src_path
      end

      # @return [Array<String>]
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

      # @param [String] target_path
      # @return [TrueClass, FalseClass]
      def orphan?(target_path)
        target_pathname = JsDependency::TargetPathname.new(target_path)
        paths = []
        target_pathname.each_parent_path(1, @index) do |parent_path, _child_path|
          paths << parent_path
        end

        paths += dir_parent_paths(target_path) if target_path.include?("index.js")

        paths.size.zero?
      end

      # @param [String] path
      # @param [String] src_path
      # @return [String]
      def relative_path_or_external_path(path, src_path)
        JsDependency::PathnameUtility.relative_path_or_external_path(path, src_path)
      end

      # Directory parent paths.
      # @param [String] target_path
      # @return [Array<String>]
      def dir_parent_paths(target_path)
        paths = []
        target_pathname_dir = JsDependency::TargetPathname.new(Pathname.new(target_path).dirname.to_s)
        target_pathname_dir.each_parent_path(1, @index) do |parent_path, _child_path|
          paths << parent_path
        end
        paths
      end
    end
  end
end
