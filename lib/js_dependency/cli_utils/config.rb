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
        @target_paths = calc_target_paths(options[:target_path], options[:target_paths], args[:target_path],
                                          args[:target_paths])
        @target_path = calc_target_path(options[:target_path], options[:target_paths], args[:target_path],
                                        args[:target_paths])
        @child_analyze_level = options[:child_analyze_level] || args[:child_analyze_level] || 2
        @parent_analyze_level = options[:parent_analyze_level] || args[:parent_analyze_level] || 2
        @output_path = options[:output_path] || args[:output_path] || nil
        @alias_paths = options[:alias_paths] || args[:alias_paths] || {}
        @name_level = options[:name_level] || args[:name_level] || 1
        @excludes = calc_excludes(options[:excludes], args[:excludes])
      end

      private

      # @param [String, Array, nil] option_target_path
      # @param [String, Array, nil] option_target_paths
      # @param [String, Array, nil] args_target_path
      # @param [String, Array, nil] args_target_paths
      # @return [nil, Array]
      def calc_target_paths(option_target_path, option_target_paths, args_target_path, args_target_paths)
        [option_target_paths, option_target_path, args_target_paths, args_target_path].each do |obj|
          return as_array(obj) if present?(obj)
        end

        nil
      end

      # @param [String, Array, nil] option_target_path
      # @param [String, Array, nil] option_target_paths
      # @param [String, Array, nil] args_target_path
      # @param [String, Array, nil] args_target_paths
      # @return [nil, String]
      def calc_target_path(option_target_path, option_target_paths, args_target_path, args_target_paths)
        [option_target_path, option_target_paths, args_target_path, args_target_paths].each do |obj|
          return as_string_or_first(obj) if present?(obj)
        end

        nil
      end

      # @param [Object] option_excludes
      # @param [Object] args_excludes
      # @return [nil, Array]
      def calc_excludes(option_excludes, args_excludes)
        [option_excludes, args_excludes].each do |obj|
          return as_array(obj) if present?(obj)
        end

        nil
      end

      # @param [Array, String, nil] obj
      # @return [TrueClass, FalseClass]
      def present?(obj)
        return false if obj.nil?
        return false if obj.empty?

        true
      end

      # @param [Array, String, nil] obj
      # @return [Array, nil]
      def as_array(obj)
        return nil if obj.nil?
        return obj if obj.is_a?(Array)

        [obj]
      end

      # @param [Array, String, nil] obj
      # @return [String, nil]
      def as_string_or_first(obj)
        return nil if obj.nil?
        return obj if obj.is_a?(String)

        return obj.first if obj.is_a?(Array)
      end
    end
  end
end
