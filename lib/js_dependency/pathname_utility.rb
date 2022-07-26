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
    def self.parse(pathname, level = -1)
      pathname.each_filename.with_object([]) { |filename, array| array << filename }.reverse[0..level].reverse
    end
  end
end
