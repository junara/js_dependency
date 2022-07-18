# frozen_string_literal: true

require_relative "nodes_link"
module JsDependency
  module Mermaid
    class Root
      attr_accessor :orientation

      def initialize(orientation = "LR")
        @orientation = orientation
        @list = []
      end

      def add(parent, child)
        @list << NodesLink.new(parent, child)
      end

      def export(name_level: 1)
        str = "flowchart #{orientation}\n"
        str + @list.sort_by(&:parent).uniq { |link| "#{link.parent}__#{link.child}" }.map do |link|
          "#{link.parent_module_name(name_level)} --> #{link.child_module_name(name_level)}"
        end.join("\n")
      end
    end
  end
end
