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

      # @param [String] src_path
      # @return [JsDependency::Mermaid::NodesLink]
      def relative_path_from(src_path)
        NodesLink.new(
          relative_parent_path(src_path),
          relative_child_path(src_path)
        )
      end

      private

      # @param [String] src_path
      # @return [String]
      def relative_parent_path(src_path)
        parent.exist? ? parent.realpath.relative_path_from(Pathname.new(src_path).realpath.to_s).to_s : parent.to_s
      end

      # @param [String] src_path
      # @return [String]
      def relative_child_path(src_path)
        child.exist? ? child.realpath.relative_path_from(Pathname.new(src_path).realpath.to_s).to_s : child.to_s
      end

      # @param [Pathname] pathname
      # @param [Integer] level
      # @return [String]
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
