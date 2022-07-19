# frozen_string_literal: true

module JsDependency
  class ExtractImportPath
    # @param [String] str
    def initialize(str)
      @str = str
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    # @return [Array<String>]
    def call
      str = @str
      # import defaultExport from 'module-name';
      paths = str.gsub(/import\s+\S+\s+from\s+"([^"]+)"/).with_object([]) { |_, list| list << Regexp.last_match(1) }
      paths += str.gsub(/import\s+\S+\s+from\s+'([^']+)'/).with_object([]) { |_, list| list << Regexp.last_match(1) }

      # import * as name from \"module-name\";
      paths += str.gsub(/import\s+\S+\s+as\s+\S+\s+from\s+"([^"]+)"/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end
      paths += str.gsub(/import\s+\S+\s+as\s+\S+\s+from\s+'([^']+)'/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end

      # import { export1 } from \"module-name\";
      # import { export1 as alias1 } from "module-name";
      # import { export1 , export2 } from "module-name";
      # import { foo , bar } from "module-name/path/to/specific/un-exported/file";
      # import { export1 , export2 as alias2 , [...] } from "module-name";
      paths += str.gsub(/import\s+\{\s+.+\s+\}\s+from\s+"([^"]+)"/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end
      paths += str.gsub(/import\s+\{\s+.+\s+\}\s+from\s+'([^']+)'/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end

      # import defaultExport, { export1 [ , [...] ] } from "module-name";
      paths += str.gsub(/import\s+\S+,\s+\{\s+.+\s+\}\s+from\s+"([^"]+)"/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end
      paths += str.gsub(/import\s+\S+,\s+\{\s+.+\s+\}\s+from\s+'([^']+)'/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end

      # import defaultExport, * as name from "module-name";
      paths += str.gsub(/import\s+\S+,\s+.+\s+as\s+\S+\s+from\s+"([^"]+)"/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end
      paths += str.gsub(/import\s+\S+,\s+.+\s+as\s+\S+\s+from\s+'([^']+)'/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end

      # import "module-name";
      paths += str.gsub(/import\s+"([^"]+)"/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end
      paths += str.gsub(/import\s+'([^']+)'/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end

      # var promise = import("module-name");
      paths += str.gsub(/import\("([^"]+)"\)/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end
      paths += str.gsub(/import\('([^']+)'\)/).with_object([]) do |_, list|
        list << Regexp.last_match(1)
      end
      paths.uniq.sort
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def self.call(str)
      new(str).call
    end
  end
end
