# frozen_string_literal: true

module JsDependency
  module PathnameUtility
    def self.complement_extname(pathname)
      return pathname if pathname.exist? || pathname.extname != ""

      %w[.js .jsx .vue].each do |ext|
        next unless pathname.sub_ext(ext).file?

        return pathname.sub_ext(ext)
      end

      pathname
    end

    def self.to_target_pathname(target_path)
      if Pathname.new(target_path).relative? && Pathname.new(target_path).exist?
        Pathname.new(target_path).realpath
      else
        Pathname.new(target_path)
      end
    end
  end
end
