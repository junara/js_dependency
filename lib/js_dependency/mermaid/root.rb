# frozen_string_literal: true

require_relative "nodes_link"
module JsDependency
  module Mermaid
    class Root
      attr_accessor :orientation
      attr_reader :list

      # @param [String] orientation
      def initialize(orientation = "LR")
        @orientation = orientation
        @list = []
      end

      # @param [String] parent
      # @param [String] child
      def add(parent, child)
        @list << NodesLink.new(parent, child)
      end

      # @param [Integer] name_level
      # @param [nil, String] src_path
      # @return [String]
      def export(name_level: 1, src_path: nil)
        ([export_header] + export_nodes(name_level: name_level, src_path: src_path)).join("\n")
      end

      # @return [String]
      def export_header
        "flowchart #{orientation}"
      end

      # @param [Integer] name_level
      # @param [nil, String] src_path
      # @return [Array<String>]
      def export_nodes(name_level: 1, src_path: nil)
        nodes_links = if src_path
                        src_pathname = Pathname.new(src_path).realpath
                        @list.map do |nodes_link|
                          NodesLink.new(nodes_link.parent.exist? ? nodes_link.parent.relative_path_from(src_pathname.to_s) : nodes_link.parent.to_s,
                                        nodes_link.child.exist? ? nodes_link.child.relative_path_from(src_pathname.to_s) : nodes_link.child.to_s)
                        end
                      else
                        @list
                      end
        nodes_links.uniq do |link|
          "#{link.parent}__#{link.child}"
        end.sort_by { |link| "#{link.parent}__#{link.child}" }.map do |link|
          "#{link.parent_module_name(name_level)} --> #{link.child_module_name(name_level)}"
        end
      end
    end
  end
end
