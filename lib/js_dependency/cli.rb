# frozen_string_literal: true

require "thor"
require "yaml"

module JsDependency
  class Cli < Thor
    default_command :export_mermaid

    desc "export_mermaid", "Output mermaid flowchart string."
    option :src_path, type: :string, aliases: "-s", desc: "Root folder."
    option :target_paths, type: :array, aliases: "-t", desc: "Target file that you want to analyze."
    option :output_path, type: :string, aliases: "-o", desc: "Output file path"
    option :child_analyze_level, type: :numeric, aliases: "-c", desc: "Output level of child dependency"
    option :parent_analyze_level, type: :numeric, aliases: "-p", desc: "Output level of parent dependency"
    option :name_level, type: :numeric, aliases: "-n", desc: "Output name level"
    option :excludes, type: :array, aliases: "-e", desc: "Exclude the word that is included in the path"

    def export_mermaid
      pathname = Pathname.new(".js_dependency.yml")
      args = {}
      args = YAML.safe_load(pathname.read) if pathname.exist?

      src_path = options[:src_path] || args["src_path"]
      target_paths = options[:target_paths] || (args["target_path"].is_a?(String) ? [args["target_path"]] : args["target_path"])
      child_analyze_level = options[:child_analyze_level] || args["child_analyze_level"] || 2
      parent_analyze_level = options[:parent_analyze_level] || args["parent_analyze_level"] || 2
      output_path = options[:output_path] || args["output_path"] || nil
      alias_paths = args["alias_paths"] || nil
      name_level = options[:name_level] || args["name_level"] || 1
      excludes = if options[:excludes].length.positive?
                   options[:excludes]
                 elsif args["excludes"]
                   args["excludes"]
                 end

      str = JsDependency.export_mermaid(
        src_path,
        target_paths,
        child_analyze_level: child_analyze_level,
        parent_analyze_level: parent_analyze_level,
        output_path: output_path,
        alias_paths: alias_paths,
        name_level: name_level,
        excludes: excludes
      )

      puts str
    end

    desc "parents", "export parents list"
    option :src_path, type: :string, aliases: "-s", desc: "Root folder."
    option :target_path, type: :string, aliases: "-t", desc: "Target file that you want to analyze."
    option :output_path, type: :string, aliases: "-o", desc: "Output file path"
    option :parent_analyze_level, type: :numeric, aliases: "-p", desc: "Output level of parent dependency"
    option :excludes, type: :array, aliases: "-e", desc: "Exclude the word that is included in the path"

    def parents
      pathname = Pathname.new(".js_dependency.yml")
      args = {}
      args = YAML.safe_load(pathname.read) if pathname.exist?

      src_path = options[:src_path] || args["src_path"]
      target_path = options[:target_path] || args["target_path"]
      parent_analyze_level = options[:parent_analyze_level] || args["parent_analyze_level"] || 1
      output_path = options[:output_path] || args["output_path"] || nil
      alias_paths = args["alias_paths"] || nil
      excludes = if options[:excludes].length.positive?
                   options[:excludes]
                 elsif args["excludes"]
                   args["excludes"]
                 end

      str = JsDependency.parents(
        src_path,
        target_path,
        parent_analyze_level: parent_analyze_level,
        output_path: output_path,
        alias_paths: alias_paths,
        excludes: excludes
      ).join("\n")

      puts str
    end

    desc "children", "export children list"
    option :src_path, type: :string, aliases: "-s", desc: "Root folder."
    option :target_path, type: :string, aliases: "-t", desc: "Target file that you want to analyze."
    option :output_path, type: :string, aliases: "-o", desc: "Output file path"
    option :child_analyze_level, type: :numeric, aliases: "-c", desc: "Output level of child dependency"
    option :excludes, type: :array, aliases: "-e", desc: "Exclude the word that is included in the path"

    def children
      pathname = Pathname.new(".js_dependency.yml")
      args = {}
      args = YAML.safe_load(pathname.read) if pathname.exist?

      src_path = options[:src_path] || args["src_path"]
      target_path = options[:target_path] || args["target_path"]
      child_analyze_level = options[:child_analyze_level] || args["child_analyze_level"] || 1
      output_path = options[:output_path] || args["output_path"] || nil
      alias_paths = args["alias_paths"] || nil
      excludes = if options[:excludes].length.positive?
                   options[:excludes]
                 elsif args["excludes"]
                   args["excludes"]
                 end

      str = JsDependency.children(
        src_path,
        target_path,
        child_analyze_level: child_analyze_level,
        output_path: output_path,
        alias_paths: alias_paths,
        excludes: excludes
      ).join("\n")

      puts str
    end
  end
end
