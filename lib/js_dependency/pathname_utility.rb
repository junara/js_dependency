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
  end
end
