# frozen_string_literal: true

module JsDependency
  module Mermaid
    class NodesLink
      attr_reader :parent, :child

      def initialize(parent, child)
        @parent = parent
        @child = child
      end

      def parent_module_name(level = 0)
        parse(Pathname.new(@parent), level).join("/")
      end

      def child_module_name(level = 0)
        parse(Pathname.new(@child), level).join("/")
      end

      private

      def parse(pathname, level)
        return [pathname.to_s] unless pathname.exist?

        array = [pathname.basename]
        level.times do
          array.unshift(pathname.parent.basename.to_s)
          pathname = pathname.parent
        end
        array
      end
    end
  end
end
