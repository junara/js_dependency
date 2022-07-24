# frozen_string_literal: true

module JsDependency
  module Mermaid
    class NodesLink
      attr_reader :parent, :child

      def initialize(parent, child)
        @parent = Pathname.new(parent)
        @child = Pathname.new(child)
      end

      def parent_module_name(level = 0)
        mermaid_str(@parent, level)
      end

      def child_module_name(level = 0)
        mermaid_str(@child, level)
      end

      private

      def mermaid_str(pathname, level = 0)
        "#{parse(pathname).join("_")}[\"#{parse(pathname, level).join("/")}\"]"
      end

      def parse(pathname, level = -1)
        pathname.each_filename.with_object([]) { |filename, array| array << filename }.reverse[0..level].reverse
      end
    end
  end
end
