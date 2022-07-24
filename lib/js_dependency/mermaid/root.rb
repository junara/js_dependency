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

      def export(name_level: 1, src_path: nil)
        nodes_links = if src_path
                        src_pathname = Pathname.new(src_path).realpath
                        @list.map do |nodes_link|
                          NodesLink.new(nodes_link.parent.exist? ? nodes_link.parent.relative_path_from(src_pathname.to_s) : nodes_link.parent.to_s,
                                        nodes_link.child.exist? ? nodes_link.child.relative_path_from(src_pathname.to_s) : nodes_link.child.to_s)
                        end
                      else
                        @list
                      end
        str = "flowchart #{orientation}\n"
        str + nodes_links.uniq do |link|
          "#{link.parent}__#{link.child}"
        end.sort_by { |link| "#{link.parent}__#{link.child}" }.map do |link|
          "#{link.parent_module_name(name_level)} --> #{link.child_module_name(name_level)}"
        end.join("\n")
      end
    end
  end
end
