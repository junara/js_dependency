# frozen_string_literal: true

module JsDependency
  module Report
    class Markdown
      attr_reader :orphan_list, :mermaid_markdown, :identifier

      # @param [Array] orphan_list
      # @param [String] mermaid_markdown
      # @param [nil, String] identifier
      def initialize(orphan_list, mermaid_markdown, identifier: nil)
        @orphan_list = orphan_list || []
        @mermaid_markdown = mermaid_markdown
        @identifier = identifier || "js_dependency_report_identifier"
      end

      # @return [String]
      def export
        markdown = <<~MAKRDOWNTEXT
          ## JsDependency Reports

          ### Orphan modules

        MAKRDOWNTEXT

        if @orphan_list.empty?
          markdown += "No orphaned module !\n\n"
        else
          markdown += "#{@orphan_list.size} orphaned modules.\n\n"
          markdown += "#{@orphan_list.map { |str| "* ``#{str}``" }.join("\n")}\n\n"
        end

        markdown += "### Module dependency\n\n"

        if @mermaid_markdown.nil? || @mermaid_markdown.empty?
          markdown += ".vue or .js or .jsx files are not changed.\n\n"
        else
          markdown += <<~MAKRDOWNTEXT
            ```mermaid
          MAKRDOWNTEXT

          markdown += @mermaid_markdown.to_s

          markdown += <<~MAKRDOWNTEXT
            ```

          MAKRDOWNTEXT
        end

        markdown += "<!-- #{@identifier} -->"
        markdown
      end
    end
  end
end
