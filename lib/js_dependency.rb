# frozen_string_literal: true

require_relative "js_dependency/version"
require_relative "js_dependency/index_creator"
require_relative "js_dependency/mermaid/root"
require_relative "js_dependency/cli"
require_relative "js_dependency/target_pathname"
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
  # @param [String] target_path
  # @param [String] orientation
  # @param [Hash, nil] alias_paths
  # @param [Integer] child_analyze_level
  # @param [Integer] parent_analyze_level
  # @param [Integer] name_level
  # @param [String, nil] output_path
  # @param [Array, nil] excludes
  # @return [String]
  def self.export_mermaid(src_path, target_path, orientation: "LR", alias_paths: nil, child_analyze_level: 1, parent_analyze_level: 1, name_level: 1, output_path: nil, excludes: nil)
    output_pathname = Pathname.new(output_path) if output_path
    index = JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths, excludes: excludes)

    target_pathname = JsDependency::TargetPathname.new(target_path)

    mermaid_root = JsDependency::Mermaid::Root.new(orientation)

    target_pathname.each_parent_path(parent_analyze_level, index) do |parent_path, child_path|
      mermaid_root.add(parent_path, child_path)
    end

    target_pathname.each_child_path(child_analyze_level, index) do |parent_path, child_path|
      mermaid_root.add(parent_path, child_path)
    end

    output = mermaid_root.export(name_level: name_level, src_path: src_path)
    output_pathname&.write(output)
    output
  end

  def self.parents(src_path, target_path, alias_paths: nil, parent_analyze_level: 1, output_path: nil, excludes: nil)
    output_pathname = Pathname.new(output_path) if output_path
    index = JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths, excludes: excludes)

    target_pathname = JsDependency::TargetPathname.new(target_path)
    list = []
    target_pathname.each_parent_path(parent_analyze_level, index) do |parent_path, _child_path|
      list << parent_path
    end
    output = list.uniq.sort.map do |path|
      Pathname.new(path).relative_path_from(Pathname.new(src_path).realpath.to_s)
    end
    output_pathname&.write(output.sort.join("\n"))
    output
  end

  def self.children(src_path, target_path, alias_paths: nil, child_analyze_level: 1, output_path: nil, excludes: nil)
    output_pathname = Pathname.new(output_path) if output_path
    index = JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths, excludes: excludes)

    target_pathname = JsDependency::TargetPathname.new(target_path)
    list = []
    target_pathname.each_child_path(child_analyze_level, index) do |_parent_path, child_path|
      list << child_path
    end
    output = list.uniq.sort.map do |path|
      Pathname.new(path).relative_path_from(Pathname.new(src_path).realpath.to_s)
    end
    output_pathname&.write(output.sort.join("\n"))
    output
  end
end
