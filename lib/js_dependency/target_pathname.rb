# frozen_string_literal: true

require_relative "pathname_utility"
module JsDependency
  class TargetPathname
    attr_accessor :color_css, :font_size_css

    # @param [String] target_path
    def initialize(target_path)
      @pathname = if Pathname.new(target_path).relative? && Pathname.new(target_path).exist?
                    Pathname.new(target_path).realpath
                  else
                    Pathname.new(target_path)
                  end
      @color_css = "#f9f"
      @font_size_css = "4px"
    end

    # @param [Integer] analyze_level
    # @param [Hash] index
    def each_parent_path(analyze_level, index)
      temp_paths = [@pathname.to_s]
      analyze_level.times do
        list = []
        temp_paths.each do |temp_path|
          temp_pathname = to_target_pathname(temp_path)

          list += extract_parent_paths(temp_pathname.to_s, index).each do |parent_path|
            yield parent_path, temp_pathname.to_s
          end
        end
        temp_paths = list
      end
    end

    # @param [Integer] analyze_level
    # @param [Hash] index
    def each_child_path(analyze_level, index)
      temp_paths = [@pathname.to_s]
      analyze_level.times do
        list = []
        temp_paths.each do |temp_path|
          temp_pathname = to_target_pathname(temp_path)

          list += extract_children_paths(temp_pathname.to_s, index).each do |child_path|
            yield temp_pathname.to_s, child_path
          end
        end
        temp_paths = list
      end
    end

    def mermaid_style(src_path)
      src_pathname = Pathname.new(src_path).realpath
      export_style(parse(@pathname.exist? ? @pathname.relative_path_from(src_pathname) : @pathname).join("_"))
    end

    private

    # @param [String] path
    # @return [String]
    def export_style(path)
      "style #{path} stroke:#{@color_css},stroke-width:#{@font_size_css}"
    end

    # @param [String] target_path
    # @param [Hash] index
    # @return [Array]
    def extract_parent_paths(target_path, index)
      index.each_with_object([]) do |(parent, children), list|
        list << parent if children.any?(target_path)
      end
    end

    # @param [String] target_path
    # @param [Hash] index
    # @return [Array]
    def extract_children_paths(target_path, index)
      index[target_path] || []
    end

    # @param [String] target_path
    # @return [Pathname]
    def to_target_pathname(target_path)
      JsDependency::PathnameUtility.to_target_pathname(target_path)
    end

    # @param [Pathname] pathname
    # @param [Integer] level
    def parse(pathname, level = -1)
      JsDependency::PathnameUtility.parse(pathname, level)
    end
  end
end
