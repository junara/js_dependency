# frozen_string_literal: true

require_relative "pathname_utility"
module JsDependency
  class TargetPathname
    def initialize(target_path)
      @pathname = if Pathname.new(target_path).relative? && Pathname.new(target_path).exist?
                    Pathname.new(target_path).realpath
                  else
                    Pathname.new(target_path)
                  end
    end

    def parents_paths(analyze_level, index, excludes: nil)
      temp_paths = [@pathname.to_s]
      analyze_level.times do
        list = []
        temp_paths.each do |temp_path|
          temp_pathname = JsDependency::PathnameUtility.to_target_pathname(temp_path)

          list += extract_parent_paths(temp_pathname.to_s, index).each do |parent_path|
            next if excludes&.any? { |ignore| parent_path.to_s.include?(ignore) || temp_pathname.to_s.include?(ignore) }

            yield parent_path, temp_pathname.to_s
          end
        end
        temp_paths = list
      end
    end

    def children_paths(analyze_level, index, excludes: nil)
      temp_paths = [@pathname.to_s]
      analyze_level.times do
        list = []
        temp_paths.each do |temp_path|
          temp_pathname = JsDependency::PathnameUtility.to_target_pathname(temp_path)

          list += extract_children_paths(temp_pathname.to_s, index).each do |child_path|
            next if excludes&.any? { |ignore| child_path.to_s.include?(ignore) || temp_pathname.to_s.include?(ignore) }

            yield temp_pathname.to_s, child_path
          end
        end
        temp_paths = list
      end
    end

    private

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
  end
end
