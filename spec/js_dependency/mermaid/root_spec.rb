# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::Mermaid::Root do
  describe "#initialize" do
    it "sets @orientation to 'LR'" do
      root = described_class.new
      expect(root.orientation).to eq("LR")
    end
  end

  describe "#add" do
    subject(:root) { described_class.new }

    context "when add 1 time." do
      it "list include JsDependency::Mermaid::NodesLink" do
        root.add("parent", "child")
        expect(root.list[0].class).to eq(JsDependency::Mermaid::NodesLink)
      end

      it "JsDependency::Mermaid::NodesLink has parent" do
        root.add("parent", "child")
        expect(root.list[0].parent.to_s).to eq("parent")
      end

      it "JsDependency::Mermaid::NodesLink has child" do
        root.add("parent", "child")
        expect(root.list[0].child.to_s).to eq("child")
      end
    end

    it "adds 2 times" do
      root.add("parent", "child")
      root.add("parent2", "child2")
      expect(root.list.size).to eq(2)
    end
  end

  describe "#export_header" do
    subject(:root) { described_class.new }

    it "returns 'flowchart LR'" do
      expect(root.export_header).to eq("flowchart LR")
    end
  end

  describe "#export_nodes" do
    context "when src_path is nil" do
      subject(:root) { described_class.new }

      before do
        root.add("spec/fixtures/mermaid/root/src/pages/parent.js", "spec/fixtures/mermaid/root/src/pages/child.js")
      end

      it "returns array" do
        expect(root.export_nodes).to be_a(Array)
      end

      it "returns array of mermaid formatted string" do
        expect(root.export_nodes[0]).to eq "spec_fixtures_mermaid_root_src_pages_parent.js[\"pages/parent.js\"] --> spec_fixtures_mermaid_root_src_pages_child.js[\"pages/child.js\"]"
      end
    end

    context "when only src_path is existed" do
      subject(:root) { described_class.new }

      before do
        root.add("spec/fixtures/mermaid/root/src/pages/parent.js", "spec/fixtures/mermaid/root/src/pages/child.js")
      end

      it "returns array of mermaid formatted string" do
        expect(root.export_nodes(src_path: "spec/fixtures/mermaid/root/src")[0]).to eq "pages_parent.js[\"pages/parent.js\"] --> pages_child.js[\"pages/child.js\"]"
      end
    end

    context "when src_path and name_level is existed" do
      subject(:root) { described_class.new }

      before do
        root.add("spec/fixtures/mermaid/root/src/pages/parent.js", "spec/fixtures/mermaid/root/src/pages/child.js")
      end

      where(:name_level, :expected) do
        [
          [nil, "pages_parent.js[\"pages/parent.js\"] --> pages_child.js[\"pages/child.js\"]"],
          [0, "pages_parent.js[\"parent.js\"] --> pages_child.js[\"child.js\"]"],
          [1, "pages_parent.js[\"pages/parent.js\"] --> pages_child.js[\"pages/child.js\"]"],
          [2, "pages_parent.js[\"pages/parent.js\"] --> pages_child.js[\"pages/child.js\"]"]
        ]
      end

      with_them do
        it "returns array of mermaid formatted string" do
          expect(root.export_nodes(name_level: name_level,
                                   src_path: "spec/fixtures/mermaid/root/src")[0]).to eq expected
        end

        it "returns size of array is 1" do
          expect(root.export_nodes(name_level: name_level,
                                   src_path: "spec/fixtures/mermaid/root/src").size).to eq 1
        end
      end
    end
  end

  describe "#export" do
    context "when none of parameters" do
      subject(:root) { described_class.new }

      before do
        root.add("spec/fixtures/mermaid/root/src/pages/parent.js", "spec/fixtures/mermaid/root/src/pages/child.js")
      end

      it "returns mermaid formatted string" do
        expect(root.export).to eq "flowchart LR\nspec_fixtures_mermaid_root_src_pages_parent.js[\"pages/parent.js\"] --> spec_fixtures_mermaid_root_src_pages_child.js[\"pages/child.js\"]"
      end
    end

    context "when only src_path" do
      subject(:root) { described_class.new }

      before do
        root.add("spec/fixtures/mermaid/root/src/pages/parent.js", "spec/fixtures/mermaid/root/src/pages/child.js")
      end

      it "returns mermaid formatted string" do
        expect(root.export(src_path: "spec/fixtures/mermaid/root/src")).to eq "flowchart LR\npages_parent.js[\"pages/parent.js\"] --> pages_child.js[\"pages/child.js\"]"
      end
    end

    context "when src_path and name_level is existed" do
      subject(:root) { described_class.new }

      before do
        root.add("spec/fixtures/mermaid/root/src/pages/parent.js", "spec/fixtures/mermaid/root/src/pages/child.js")
      end

      where(:name_level, :expected) do
        [
          [nil, "flowchart LR\npages_parent.js[\"pages/parent.js\"] --> pages_child.js[\"pages/child.js\"]"],
          [0, "flowchart LR\npages_parent.js[\"parent.js\"] --> pages_child.js[\"child.js\"]"],
          [1, "flowchart LR\npages_parent.js[\"pages/parent.js\"] --> pages_child.js[\"pages/child.js\"]"],
          [2, "flowchart LR\npages_parent.js[\"pages/parent.js\"] --> pages_child.js[\"pages/child.js\"]"]
        ]
      end

      with_them do
        it "returns array of mermaid formatted string" do
          expect(root.export(name_level: name_level,
                             src_path: "spec/fixtures/mermaid/root/src")).to eq expected
        end
      end
    end
  end
end
