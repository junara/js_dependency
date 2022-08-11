# frozen_string_literal: true

module JsDependency
  module CliUtils
    class Yaml
      attr_reader :args

      def initialize
        pathname = config_pathname
        @args = if pathname.nil?
                  {}
                else
                  symbolize_keys(YAML.safe_load(pathname.read))
                end
      end

      private

      # @return [Pathname, nil]
      def config_pathname
        pathname = nil
        %w[.js_dependency.yml .js_dependency.yaml].each do |path|
          pathname = Pathname.new(path) if Pathname.new(path).exist?
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
