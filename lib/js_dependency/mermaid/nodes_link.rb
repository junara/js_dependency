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
        parse(@parent, level).join("/")
      end

      def child_module_name(level = 0)
        parse(@child, level).join("/")
      end

      private

      def parse(pathname, level)
        pathname.each_filename.with_object([]) { |filename, array| array << filename }.reverse[0..level].reverse
      end
    end
  end
end
