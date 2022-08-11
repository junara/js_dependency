# frozen_string_literal: true

module JsDependency
  module CliUtils
    class Config
      attr_reader :src_path, :target_paths, :target_path, :child_analyze_level, :parent_analyze_level, :output_path,
                  :alias_paths, :name_level, :excludes

      # @param [Hash] options
      # @param [Hash] args
      def initialize(options, args)
        @src_path = options[:src_path] || args[:src_path]
        @target_paths = options[:target_paths] || (args[:target_path].is_a?(String) ? [args[:target_path]] : args[:target_path])
        @target_path = options[:target_path] || args[:target_path]
        @child_analyze_level = options[:child_analyze_level] || args[:child_analyze_level] || 2
        @parent_analyze_level = options[:parent_analyze_level] || args[:parent_analyze_level] || 2
        @output_path = options[:output_path] || args[:output_path] || nil
        @alias_paths = options[:alias_paths] || args[:alias_paths] || {}
        @name_level = options[:name_level] || args[:name_level] || 1
        @excludes = if options[:excludes]&.length&.positive?
                      options[:excludes]
                    elsif args[:excludes]
                      args[:excludes]
                    end
      end
    end
  end
end
