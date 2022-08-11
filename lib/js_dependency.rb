# frozen_string_literal: true

require_relative "js_dependency/version"
require_relative "js_dependency/index_creator"
require_relative "js_dependency/mermaid/root"
require_relative "js_dependency/cli"
require_relative "js_dependency/target_pathname"
require_relative "js_dependency/mermaid/target_pathname"
require_relative "js_dependency/source_analysis/leave"
require_relative "js_dependency/source_analysis/orphan"
require_relative "js_dependency/pathname_utility"
require_relative "js_dependency/cli_utils/yaml"
require_relative "js_dependency/cli_utils/config"
require "pathname"

module JsDependency
  class Error < StandardError; end

  # @param [String] src_path
  # @param [Hash, nil] alias_paths
  # @param [Array, nil] excludes
  # @return [Hash]
  def self.export_index(src_path, alias_paths: nil, excludes: nil)
    JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths, excludes: excludes)
  end

  # @param [String] src_path
  # @param [Hash, nil] alias_paths
  # @return [Array<String>]
  def self.leave(src_path, alias_paths: nil)
    index = JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths)
    JsDependency::SourceAnalysis::Leave.new(index, src_path).call
  end

  # @param [String] src_path
  # @param [Hash, nil] alias_paths
  # @return [Array<String>]
  def self.orphan(src_path, alias_paths: nil)
    index = JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths)
    JsDependency::SourceAnalysis::Orphan.new(index, src_path).call
  end

  # @param [String] src_path
  # @param [Array<String>] target_paths
  # @param [String] orientation
  # @param [Hash, nil] alias_paths
  # @param [Integer] child_analyze_level
  # @param [Integer] parent_analyze_level
  # @param [Integer] name_level
  # @param [String, nil] output_path
  # @param [Array, nil] excludes
  # @return [String]
  def self.export_mermaid(src_path, target_paths, orientation: "LR", alias_paths: nil, child_analyze_level: 1, parent_analyze_level: 1, name_level: 1, output_path: nil, excludes: nil)
    output_pathname = Pathname.new(output_path) if output_path
    index = JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths, excludes: excludes)

    nodes = []
    styles = []
    target_paths.each do |target_path|
      styles += [JsDependency::Mermaid::TargetPathname.new(target_path).mermaid_style(src_path)]
      mermaid_root = JsDependency::Mermaid::Root.new(orientation)

      target_pathname = JsDependency::TargetPathname.new(target_path)
      target_pathname.each_parent_path(parent_analyze_level, index) do |parent_path, child_path|
        mermaid_root.add(parent_path, child_path)
      end

      target_pathname.each_child_path(child_analyze_level, index) do |parent_path, child_path|
        mermaid_root.add(parent_path, child_path)
      end
      nodes += mermaid_root.export_nodes(name_level: name_level, src_path: src_path)
    end

    output = (["flowchart LR"] + nodes.uniq + styles.uniq).join("\n")
    output_pathname&.write(output)
    output
  end

  # @param [String] src_path
  # @param [String] target_path
  # @param [String] orientation
  # @param [Hash, nil] alias_paths
  # @param [Integer] parent_analyze_level
  # @param [String, nil] output_path
  # @param [Array, nil] excludes
  # @return [Array<Pathname>]
  def self.parents(src_path, target_path, alias_paths: nil, parent_analyze_level: 1, output_path: nil, excludes: nil)
    output_pathname = Pathname.new(output_path) if output_path
    index = JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths, excludes: excludes)

    target_pathname = JsDependency::TargetPathname.new(target_path)
    paths = []
    target_pathname.each_parent_path(parent_analyze_level, index) do |parent_path, _child_path|
      paths << parent_path
    end
    output = paths.uniq.sort.map do |path|
      JsDependency::PathnameUtility.relative_path_or_external_path(path, src_path)
    end
    output_pathname&.write(output.sort.join("\n"))
    output
  end

  # @param [String] src_path
  # @param [String] target_path
  # @param [String] orientation
  # @param [Hash, nil] alias_paths
  # @param [Integer] child_analyze_level
  # @param [String, nil] output_path
  # @param [Array, nil] excludes
  # @return [Array<Pathname>]
  def self.children(src_path, target_path, alias_paths: nil, child_analyze_level: 1, output_path: nil, excludes: nil)
    output_pathname = Pathname.new(output_path) if output_path
    index = JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths, excludes: excludes)

    target_pathname = JsDependency::TargetPathname.new(target_path)
    paths = []
    target_pathname.each_child_path(child_analyze_level, index) do |_parent_path, child_path|
      paths << child_path
    end
    output = paths.uniq.sort.map do |path|
      JsDependency::PathnameUtility.relative_path_or_external_path(path, src_path)
    end
    output_pathname&.write(output.sort.join("\n"))
    output
  end
end
