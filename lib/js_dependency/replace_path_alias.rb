# frozen_string_literal: true

module JsDependency
  class ReplacePathAlias
    # @param [String] str
    # @param [Hash, nil] alias_paths
    def initialize(str, alias_paths = nil)
      @str = str
      @alias_paths = alias_paths
    end

    # @param [String] str
    # @param [Hash, nil] alias_paths
    # @return [String]
    def self.call(str, alias_paths = nil)
      return str if alias_paths.nil? || alias_paths.empty?

      new(str, alias_paths).call
    end

    # @return [String]
    def call
      return @str if safe_list.include?(@str)

      replace_alias_paths(@str, @alias_paths)
    end

    private

    # @param [String] str
    # @param [nil, Hash] alias_paths
    def replace_alias_paths(str, alias_paths)
      alias_paths.each do |(key, value)|
        str = str.gsub(/^#{key}/, value.to_s)
      end
      str
    end

    def safe_list
      ["@rails/ujs"]
    end
  end
end
