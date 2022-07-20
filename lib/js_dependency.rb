# frozen_string_literal: true

require_relative "js_dependency/version"
require_relative "js_dependency/index_creator"
require_relative "js_dependency/mermaid/root"
require_relative "js_dependency/cli"
require "pathname"

module JsDependency
  class Error < StandardError; end

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
    index = JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths)

    target_pathname = if Pathname.new(target_path).relative? && Pathname.new(target_path).exist?
                        Pathname.new(target_path).realpath
                      else
                        Pathname.new(target_path)
                      end

    root = JsDependency::Mermaid::Root.new(orientation)

    parents_paths(target_pathname, parent_analyze_level, index, excludes: excludes) do |parent_path, child_path|
      root.add(parent_path, child_path)
    end

    children_paths(target_pathname, child_analyze_level, index, excludes: excludes) do |parent_path, child_path|
      root.add(parent_path, child_path)
    end

    output = root.export(name_level: name_level)
    output_pathname&.write(output)
    output
  end

  def self.parents(src_path, target_path, alias_paths: nil, parent_analyze_level: 1, output_path: nil, excludes: nil)
    output_pathname = Pathname.new(output_path) if output_path
    index = JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths)

    target_pathname = if Pathname.new(target_path).relative? && Pathname.new(target_path).exist?
                        Pathname.new(target_path).realpath
                      else
                        Pathname.new(target_path)
                      end
    list = []
    parents_paths(target_pathname, parent_analyze_level, index, excludes: excludes) do |parent_path, _child_path|
      list << parent_path
    end
    output = list.uniq
    output_pathname&.write(output.sort.join("\n"))
    output
  end

  def self.children(src_path, target_path, alias_paths: nil, child_analyze_level: 1, output_path: nil, excludes: nil)
    output_pathname = Pathname.new(output_path) if output_path
    index = JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths)

    target_pathname = if Pathname.new(target_path).relative? && Pathname.new(target_path).exist?
                        Pathname.new(target_path).realpath
                      else
                        Pathname.new(target_path)
                      end
    list = []
    children_paths(target_pathname, child_analyze_level, index, excludes: excludes) do |_parent_path, child_path|
      list << child_path
    end
    output = list.uniq
    output_pathname&.write(output.sort.join("\n"))
    output
  end

  # @param [String] target_path
  # @param [Hash] index
  # @return [Array]
  def self.extract_parent_paths(target_path, index)
    target_pathname = if Pathname.new(target_path).exist?
                        Pathname.new(target_path).realpath
                      else
                        Pathname.new(target_path)
                      end
    index.each_with_object([]) do |(parent, children), list|
      list << parent if children.any?(target_pathname.to_s)
    end
  end

  private_class_method :extract_parent_paths

  # @param [String] target_path
  # @param [Hash] index
  # @return [Array]
  def self.extract_children_paths(target_path, index)
    target_pathname = if Pathname.new(target_path).exist?
                        Pathname.new(target_path).realpath
                      else
                        Pathname.new(target_path)
                      end
    index[target_pathname.to_s] || []
  end

  private_class_method :extract_children_paths

  # @param [String] src
  # @param [nil, Hash] alias_paths
  def self.create_index(src_path, alias_paths: nil)
    JsDependency::IndexCreator.call(src_path, alias_paths: alias_paths)
  end

  private_class_method :create_index

  def self.parents_paths(target_pathname, analyze_level, index, excludes: nil)
    temp_paths = [target_pathname.to_s]
    analyze_level.times do
      list = []
      temp_paths.each do |temp_path|
        temp_pathname = if Pathname.new(temp_path).relative? && Pathname.new(temp_path).exist?
                          Pathname.new(temp_path).realpath
                        else
                          Pathname.new(temp_path)
                        end

        list += extract_parent_paths(temp_pathname.to_s, index).each do |parent_path|
          next if excludes&.any? { |ignore| parent_path.to_s.include?(ignore) }

          yield parent_path, temp_pathname.to_s
        end
      end
      temp_paths = list
    end
  end

  private_class_method :parents_paths

  def self.children_paths(target_pathname, analyze_level, index, excludes: nil)
    temp_paths = [target_pathname.to_s]
    analyze_level.times do
      list = []
      temp_paths.each do |temp_path|
        temp_pathname = if Pathname.new(temp_path).relative? && Pathname.new(temp_path).exist?
                          Pathname.new(temp_path).realpath
                        else
                          Pathname.new(temp_path)
                        end

        list += extract_children_paths(temp_pathname.to_s, index).each do |child_path|
          next if excludes&.any? { |ignore| child_path.to_s.include?(ignore) }

          yield temp_pathname.to_s, child_path
        end
      end
      temp_paths = list
    end
  end

  private_class_method :children_paths
end
