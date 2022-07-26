# frozen_string_literal: true

require_relative "../pathname_utility"

module JsDependency
  module Mermaid
    class NodesLink
      attr_reader :parent, :child

      # @param [String] parent
      # @param [String] child
      def initialize(parent, child)
        @parent = Pathname.new(parent)
        @child = Pathname.new(child)
      end

      # @param [Integer] level
      # @return [String]
      def parent_module_name(level = 0)
        mermaid_str(@parent, level)
      end

      # @param [Integer] level
      # @return [String]
      def child_module_name(level = 0)
        mermaid_str(@child, level)
      end

      private

      # @param [Pathname] pathname
      # @param [Integer] level
      def mermaid_str(pathname, level = 0)
        "#{parse(pathname).join("_")}[\"#{parse(pathname, level).join("/")}\"]"
      end

      # @param [Pathname] pathname
      # @param [Integer] level
      def parse(pathname, level = -1)
        JsDependency::PathnameUtility.parse(pathname, level)
      end
    end
  end
end
