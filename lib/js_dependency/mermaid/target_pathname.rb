# frozen_string_literal: true

require_relative "../pathname_utility"
module JsDependency
  module Mermaid
    class TargetPathname
      attr_accessor :color_css, :font_size_css

      # @param [String] target_path
      def initialize(target_path)
        @pathname = to_target_pathname(target_path)
        @color_css = "#f9f"
        @font_size_css = "4px"
      end

      def mermaid_style(src_path)
        src_pathname = Pathname.new(src_path).realpath
        export_style(parse(@pathname.exist? ? @pathname.relative_path_from(src_pathname) : @pathname).join("_"))
      end

      private

      # @param [String] path
      # @return [String]
      def export_style(path)
        "style #{path} stroke:#{@color_css},stroke-width:#{@font_size_css}"
      end

      # @param [Pathname] pathname
      # @param [Integer] level
      def parse(pathname, level = -1)
        JsDependency::PathnameUtility.parse(pathname, level)
      end

      def to_target_pathname(target_path)
        JsDependency::PathnameUtility.to_target_pathname(target_path)
      end
    end
  end
end
