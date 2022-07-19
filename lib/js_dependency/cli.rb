# frozen_string_literal: true

require "thor"
require "yaml"

module JsDependency
  class Cli < Thor
    default_command :export_mermaid

    desc "export_mermaid", "Output mermaid flowchart string."
    option :src_path, type: :string, aliases: "-s", desc: "Root folder."
    option :target_path, type: :string, aliases: "-t", desc: "Target file that you want to analyze."
    option :output_path, type: :string, aliases: "-o", desc: "Output file path"
    option :child_analyze_level, type: :numeric, aliases: "-c", desc: "Output level of child dependency"
    option :parent_analyze_level, type: :numeric, aliases: "-p", desc: "Output level of parent dependency"
    option :name_level, type: :numeric, aliases: "-n", desc: "Output name level"
    def export_mermaid
      pathname = Pathname.new(".js_dependency.yml")
      args = {}
      args = YAML.safe_load(pathname.read) if pathname.exist?

      src_path = options[:src_path] || args["src_path"]
      target_path = options[:target_path] || args["target_path"]
      child_analyze_level = options[:child_analyze_level] || args["child_analyze_level"] || 2
      parent_analyze_level = options[:parent_analyze_level] || args["parent_analyze_level"] || 2
      output_path = options[:output_path] || args["output_path"] || nil
      alias_paths = args["alias_paths"] || nil
      name_level = options[:name_level] || args["name_level"] || 1

      str = JsDependency.export_mermaid(
        src_path,
        target_path,
        child_analyze_level: child_analyze_level,
        parent_analyze_level: parent_analyze_level,
        output_path: output_path,
        alias_paths: alias_paths,
        name_level: name_level
      )

      puts str
    end
  end
end
