# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::Report::Markdown do
  describe "#initialize" do
    where(:orphan_list, :mermaid_markdown, :identifier, :expected_orphan_list, :expected_mermaid_markdown, :expected_identifier) do
      [
        [nil, nil, nil, [], nil, "js_dependency_report_identifier"],
        [%w[a b], "txt", nil, %w[a b], "txt", "js_dependency_report_identifier"],
        [%w[a b], "txt", "uniq_identifier", %w[a b], "txt", "uniq_identifier"]
      ]
    end
    with_them do
      subject(:markdown) { described_class.new(orphan_list, mermaid_markdown, identifier: identifier) }

      it { expect(markdown.orphan_list).to eq(expected_orphan_list) }

      it { expect(markdown.mermaid_markdown).to eq(expected_mermaid_markdown) }

      it { expect(markdown.identifier).to eq(expected_identifier) }
    end
  end

  describe "#export" do
    context "when all attributes are present" do
      subject(:markdown) { described_class.new(%w[orphan_a orphan_b], "markdown_text", identifier: "identifier") }

      it "returns formatted report" do
        expect(markdown.export).to be_a(String)
      end

      it { expect(markdown.export).to include("orphan_a") }
      it { expect(markdown.export).to include("orphan_b") }
      it { expect(markdown.export).to include("```mermaid\n") }
      it { expect(markdown.export).to include("markdown_text") }
      it { expect(markdown.export).to include("```\n") }
      it { expect(markdown.export).to include("<!-- identifier -->") }
    end

    context "when orphan_list is empty" do
      subject(:markdown) { described_class.new([], "markdown_text", identifier: "identifier") }

      it "returns formatted report" do
        expect(markdown.export).to be_a(String)
      end

      it { expect(markdown.export).to include("No orphaned module") }
    end

    context "when orphan_list is nil" do
      subject(:markdown) { described_class.new(nil, "markdown_text", identifier: "identifier") }

      it "returns formatted report" do
        expect(markdown.export).to be_a(String)
      end

      it { expect(markdown.export).to include("No orphaned module") }
    end

    context "when identifier is empty" do
      subject(:markdown) { described_class.new(%w[orphan_a orphan_b], "markdown_text", identifier: nil) }

      it "returns formatted report" do
        expect(markdown.export).to be_a(String)
      end

      it { expect(markdown.export).to include("js_dependency_report_identifier") }
    end

    context "when mermaid_markdown is empty" do
      subject(:markdown) { described_class.new(%w[orphan_a orphan_b], nil, identifier: nil) }

      it "returns formatted report" do
        expect(markdown.export).to be_a(String)
      end

      it { expect(markdown.export).to include(".vue or .js or .jsx files are not changed.") }
    end
  end
end
