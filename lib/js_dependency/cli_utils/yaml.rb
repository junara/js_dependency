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
                  symbolize_keys(YAML.safe_load(config_pathname.read))
                end
      end

      private

      def config_pathname
        if Pathname.new(".js_dependency.yml").exist?
          Pathname.new(".js_dependency.yml")
        elsif Pathname.new(".js_dependency.yaml").exist?
          Pathname.new(".js_dependency.yaml")
        end
      end

      def symbolize_keys(hash)
        hash.transform_keys(&:to_sym)
      end
    end
  end
end
