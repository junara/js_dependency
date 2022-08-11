# frozen_string_literal: true

require "thor"
require "yaml"

module JsDependency
  class Cli < Thor
    default_command :export_mermaid

    desc "export_mermaid", "Output mermaid flowchart string."
    method_option :src_path, type: :string, aliases: "-s", desc: "Root folder."
    method_option :target_paths, type: :array, aliases: "-t", desc: "Target file that you want to analyze."
    method_option :output_path, type: :string, aliases: "-o", desc: "Output file path"
    method_option :child_analyze_level, type: :numeric, aliases: "-c", desc: "Output level of child dependency"
    method_option :parent_analyze_level, type: :numeric, aliases: "-p", desc: "Output level of parent dependency"
    method_option :name_level, type: :numeric, aliases: "-n", desc: "Output name level"
    method_option :excludes, type: :array, aliases: "-e", desc: "Exclude the word that is included in the path"

    def export_mermaid
      args = JsDependency::CliUtils::Yaml.new.args
      config = JsDependency::CliUtils::Config.new(options, args)
      str = JsDependency.export_mermaid(
        config.src_path,
        config.target_paths,
        child_analyze_level: config.child_analyze_level,
        parent_analyze_level: config.parent_analyze_level,
        output_path: config.output_path,
        alias_paths: config.alias_paths,
        name_level: config.name_level,
        excludes: config.excludes
      )

      puts str
    end

    desc "parents", "export parents list"
    method_option :src_path, type: :string, aliases: "-s", desc: "Root folder."
    method_option :target_path, type: :string, aliases: "-t", desc: "Target file that you want to analyze."
    method_option :output_path, type: :string, aliases: "-o", desc: "Output file path"
    method_option :parent_analyze_level, type: :numeric, aliases: "-p", desc: "Output level of parent dependency"
    method_option :excludes, type: :array, aliases: "-e", desc: "Exclude the word that is included in the path"

    def parents
      args = JsDependency::CliUtils::Yaml.new.args
      config = JsDependency::CliUtils::Config.new(options, args)

      str = JsDependency.parents(
        config.src_path,
        config.target_path,
        parent_analyze_level: config.parent_analyze_level,
        output_path: config.output_path,
        alias_paths: config.alias_paths,
        excludes: config.excludes
      ).join("\n")

      puts str
    end

    desc "children", "export children list"
    method_option :src_path, type: :string, aliases: "-s", desc: "Root folder."
    method_option :target_path, type: :string, aliases: "-t", desc: "Target file that you want to analyze."
    method_option :output_path, type: :string, aliases: "-o", desc: "Output file path"
    method_option :child_analyze_level, type: :numeric, aliases: "-c", desc: "Output level of child dependency"
    method_option :excludes, type: :array, aliases: "-e", desc: "Exclude the word that is included in the path"

    def children
      args = JsDependency::CliUtils::Yaml.new.args
      config = JsDependency::CliUtils::Config.new(options, args)

      str = JsDependency.children(
        config.src_path,
        config.target_path,
        child_analyze_level: config.child_analyze_level,
        output_path: config.output_path,
        alias_paths: config.alias_paths,
        excludes: config.excludes
      ).join("\n")

      puts str
    end

    desc "orphan", "export components than is not depended by others"
    method_option :src_path, type: :string, aliases: "-s", desc: "Root folder."

    def orphan
      args = JsDependency::CliUtils::Yaml.new.args
      config = JsDependency::CliUtils::Config.new(options, args)

      str = JsDependency.orphan(
        config.src_path,
        alias_paths: config.alias_paths
      ).join("\n")

      puts str
    end

    desc "leave", "export components than is not depended by others"
    method_option :src_path, type: :string, aliases: "-s", desc: "Root folder."

    def leave
      args = JsDependency::CliUtils::Yaml.new.args
      config = JsDependency::CliUtils::Config.new(options, args)

      str = JsDependency.leave(
        config.src_path,
        alias_paths: config.alias_paths
      ).join("\n")

      puts str
    end

    desc "version", "show version"
    def version
      puts JsDependency::VERSION
    end
  end
end
