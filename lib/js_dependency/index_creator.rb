# frozen_string_literal: true

require_relative "extract_script_tag"
require_relative "extract_import_path"
require_relative "replace_path_alias"
require_relative "pathname_utility"

module JsDependency
  class IndexCreator
    def initialize(src, alias_paths: nil)
      @src = src
      @alias_paths = alias_paths
    end

    def self.call(src, alias_paths: nil, excludes: nil)
      index = new(src, alias_paths: alias_paths).call
      index.transform_values do |value|
        value.reject { |path| excludes&.any? { |exclude| path.include?(exclude) } }
      end
    end

    def call
      src_pathname = Pathname.new(@src).relative? ? Pathname.new(@src).realpath : Pathname.new(@src)
      raise Error, "#{@src} is not directory." unless src_pathname.directory?

      alias_paths = @alias_paths&.transform_values do |path|
        Pathname.new(path).relative? ? src_pathname + Pathname.new(path) : Pathname.new(path)
      end
      index_from(src_pathname, alias_paths)
    end

    private

    def index_from(src_pathname, alias_paths)
      pattern = %w[**/*.vue **/*.js **/*.jsx]

      src_pathname.glob(pattern).each_with_object({}) do |component_pathname, obj|
        import_pathnames = import_pathnames_from(component_pathname, alias_paths)

        obj[component_pathname.to_s] = import_pathnames.map(&:to_s)
        if component_pathname.basename.to_s == "index.js"
          obj[component_pathname.dirname.to_s] = import_pathnames.map(&:to_s)
        end
      end
    end

    def import_pathnames_from(component_pathname, alias_paths)
      component_dirname = component_pathname.dirname
      script_str = extract_script_string(component_pathname)
      JsDependency::ExtractImportPath.call(script_str).map do |import_path|
        standardize_path(import_path, alias_paths, component_dirname)
      end
    end

    def standardize_path(import_path, alias_paths, component_dirname)
      import_pathname = Pathname.new(replace_path_alias(import_path, alias_paths))

      # Convert relative path to absolute path
      if import_pathname.relative? &&
         JsDependency::PathnameUtility.complement_extname((component_dirname + Pathname.new(import_path))).exist?
        import_pathname = (component_dirname + Pathname.new(import_path))
      end

      # Complement extname (vue, js, jsx) if it is not exist
      import_pathname = JsDependency::PathnameUtility.complement_extname(import_pathname)

      import_pathname.cleanpath
    end

    def extract_script_string(pathname)
      str = pathname.read
      extname = pathname.extname
      return str unless extname == ".vue"

      JsDependency::ExtractScriptTag.call(str)
    end

    def replace_path_alias(path, alias_paths)
      JsDependency::ReplacePathAlias.call(path, alias_paths)
    end
  end
end
