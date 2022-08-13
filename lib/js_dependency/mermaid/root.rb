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
                        @list.map { |nodes_link| nodes_link.relative_path_from(src_path) }
                      else
                        @list
                      end
        nodes_links = nodes_links.uniq { |nodes_link| "#{nodes_link.parent}__#{nodes_link.child}" }
        nodes_links = nodes_links.sort_by { |nodes_link| "#{nodes_link.parent}__#{nodes_link.child}" }
        nodes_links.map do |nodes_link|
          "#{nodes_link.parent_module_name(name_level)} --> #{nodes_link.child_module_name(name_level)}"
        end
      end
    end
  end
end
