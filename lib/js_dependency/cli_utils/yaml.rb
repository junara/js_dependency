# frozen_string_literal: true

module JsDependency
  module CliUtils
    class Yaml
      attr_reader :dir_path,
                  :path

      # @param [String, nil] dir_path
      # @param [String, nil] path
      def initialize(dir_path: nil, path: nil)
        @dir_path = present?(dir_path) ? dir_path : Dir.pwd
        @path = path
      end

      # @return [Hash]
      def args
        pathname = if present?(@path)
                     Pathname.new(@path)
                   else
                     config_pathname
                   end

        if pathname.nil?
          {}
        else
          symbolize_keys(YAML.safe_load(pathname.read))
        end
      end

      private

      # @param [String] str
      # @return [TrueClass, FalseClass]
      def present?(str)
        return false if str.nil?
        return false if str.empty?

        true
      end

      # @return [Pathname, nil]
      def config_pathname
        dir_pathname = Pathname.new(@dir_path)
        pathname = nil
        %w[.js_dependency.yml .js_dependency.yaml].each do |path|
          pathname = (dir_pathname + path) if (dir_pathname + path).exist?
        end
        pathname
      end

      # @param [Hash] hash
      # @return [Hash]
      def symbolize_keys(hash)
        hash.transform_keys(&:to_sym)
      end
    end
  end
end
