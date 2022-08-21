# frozen_string_literal: true

module JsDependency
  module PathnameUtility
    # @param [Pathname] pathname
    # @return [Pathname]
    def self.complement_extname(pathname)
      return pathname if pathname.exist? || pathname.extname != ""

      %w[.js .jsx .vue].each do |ext|
        next unless pathname.sub_ext(ext).file?

        return pathname.sub_ext(ext)
      end

      pathname
    end

    # @param [String] target_path
    # @return [Pathname]
    def self.to_target_pathname(target_path)
      if Pathname.new(target_path).relative? && Pathname.new(target_path).exist?
        Pathname.new(target_path).realpath
      else
        Pathname.new(target_path)
      end
    end

    # @param [Pathname] pathname
    # @param [Integer] level
    # @return [Array]
    def self.parse(pathname, level = -1)
      pathname.each_filename.with_object([]) { |filename, array| array << filename }.reverse[0..level].reverse
    end

    # @param [String] path
    # @param [String] src_path
    # @return [String]
    def self.relative_path_or_external_path(path, src_path)
      pathname = Pathname.new(path)
      src_pathname = Pathname.new(src_path)

      if pathname.exist?
        pathname.realpath.relative_path_from(src_pathname.realpath.to_s).to_s
      else
        pathname.to_s
      end
    end

    # @param [Array<String>] paths
    # @return [Array<String>]
    def self.filter_js_files(paths)
      return paths if paths.nil? || paths.empty?

      permitted_extnames = %w[.js .vue .jsx]
      paths.filter { |path| permitted_extnames.include?(Pathname.new(path).extname) }
    end
  end
end
