# frozen_string_literal: true

module JsDependency
  module Extractor
    class ExtractSrcPath
      # @param [String] str
      def initialize(str)
        @str = str
      end

      # Extract JavaScript file (.js) in src path
      # @return [Array<String>]
      def call
        str = @str
        # <script src="module-name.js">
        paths = str.gsub(/<script\s+src="([^']+)">/).with_object([]) { |_, list| list << Regexp.last_match(1) }
        paths += str.gsub(/<script\s+src='([^']+)'>/).with_object([]) { |_, list| list << Regexp.last_match(1) }

        filter_javascript_paths(paths).uniq.sort
      end

      def self.call(str)
        new(str).call
      end

      private

      # Filter JavaScript file (.js) from Array of String
      # @param [Array<String>] paths
      # @return [Array<String>]
      def filter_javascript_paths(paths)
        paths.filter do |path|
          path.end_with?(".js")
        end
      end
    end
  end
end
