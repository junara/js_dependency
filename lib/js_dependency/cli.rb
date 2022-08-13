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
    method_option :alias_paths, type: :hash, aliases: "-a", desc: "Alias paths by hash format."
    method_option :file_config, type: :string, aliases: "-f", desc: "Configuration file path."

    def export_mermaid
      args = JsDependency::CliUtils::Yaml.new(path: options[:file_config]).args
      config = JsDependency::CliUtils::Config.new(options, args)
      puts JsDependency.export_mermaid(
        config.src_path,
        config.target_paths,
        child_analyze_level: config.child_analyze_level,
        parent_analyze_level: config.parent_analyze_level,
        output_path: config.output_path,
        alias_paths: config.alias_paths,
        name_level: config.name_level,
        excludes: config.excludes
      )
    end

    desc "parents", "export parents list"
    method_option :src_path, type: :string, aliases: "-s", desc: "Root folder."
    method_option :target_path, type: :string, aliases: "-t", desc: "Target file that you want to analyze."
    method_option :output_path, type: :string, aliases: "-o", desc: "Output file path"
    method_option :parent_analyze_level, type: :numeric, aliases: "-p", desc: "Output level of parent dependency"
    method_option :excludes, type: :array, aliases: "-e", desc: "Exclude the word that is included in the path"
    method_option :alias_paths, type: :hash, aliases: "-a", desc: "Alias paths by hash format."
    method_option :file_config, type: :string, aliases: "-f", desc: "Configuration file path."

    def parents
      args = JsDependency::CliUtils::Yaml.new(path: options[:file_config]).args
      config = JsDependency::CliUtils::Config.new(options, args)
      puts JsDependency.parents(
        config.src_path,
        config.target_path,
        parent_analyze_level: config.parent_analyze_level,
        output_path: config.output_path,
        alias_paths: config.alias_paths,
        excludes: config.excludes
      ).join("\n")
    end

    desc "children", "export children list"
    method_option :src_path, type: :string, aliases: "-s", desc: "Root folder."
    method_option :target_path, type: :string, aliases: "-t", desc: "Target file that you want to analyze."
    method_option :output_path, type: :string, aliases: "-o", desc: "Output file path"
    method_option :child_analyze_level, type: :numeric, aliases: "-c", desc: "Output level of child dependency"
    method_option :excludes, type: :array, aliases: "-e", desc: "Exclude the word that is included in the path"
    method_option :alias_paths, type: :hash, aliases: "-a", desc: "Alias paths by hash format."
    method_option :file_config, type: :string, aliases: "-f", desc: "Configuration file path."

    def children
      args = JsDependency::CliUtils::Yaml.new(path: options[:file_config]).args
      config = JsDependency::CliUtils::Config.new(options, args)
      puts JsDependency.children(
        config.src_path,
        config.target_path,
        child_analyze_level: config.child_analyze_level,
        output_path: config.output_path,
        alias_paths: config.alias_paths,
        excludes: config.excludes
      ).join("\n")
    end

    desc "orphan", "export components than is not depended by others"
    method_option :src_path, type: :string, aliases: "-s", desc: "Root folder."
    method_option :alias_paths, type: :hash, aliases: "-a", desc: "Alias paths by hash format."
    method_option :file_config, type: :string, aliases: "-f", desc: "Configuration file path."

    def orphan
      args = JsDependency::CliUtils::Yaml.new(path: options[:file_config]).args
      config = JsDependency::CliUtils::Config.new(options, args)
      puts JsDependency.orphan(
        config.src_path,
        alias_paths: config.alias_paths
      ).join("\n")
    end

    desc "leave", "export components than is not depended by others"
    method_option :src_path, type: :string, aliases: "-s", desc: "Root folder."
    method_option :alias_paths, type: :hash, aliases: "-a", desc: "Alias paths by hash format."
    method_option :file_config, type: :string, aliases: "-f", desc: "Configuration file path."

    def leave
      args = JsDependency::CliUtils::Yaml.new(path: options[:file_config]).args
      config = JsDependency::CliUtils::Config.new(options, args)
      puts JsDependency.leave(
        config.src_path,
        alias_paths: config.alias_paths
      ).join("\n")
    end

    desc "version", "show version"
    def version
      puts JsDependency::VERSION
    end
  end
end
