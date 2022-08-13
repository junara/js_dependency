# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::Mermaid::NodesLink do
  describe "#initialize" do
    context "when initialize with parent and child" do
      subject(:nodes_link) do
        described_class.new(parent, child)
      end

      let(:parent) { "path/to/parent.js" }
      let(:child) { "path/to/child.js" }

      it "return parent pathname" do
        expect(nodes_link.parent).to eq(Pathname.new(parent))
      end

      it "return child pathname" do
        expect(nodes_link.child).to eq(Pathname.new(child))
      end
    end
  end

  describe "#parent_module_name" do
    subject(:nodes_link) do
      described_class.new(parent, child)
    end

    let(:parent) { "path/to/parent.js" }
    let(:child) { "path/to/child.js" }

    where(:level, :expected) do
      [
        [nil, "path_to_parent.js[\"path/to/parent.js\"]"],
        [0, "path_to_parent.js[\"parent.js\"]"],
        [1, "path_to_parent.js[\"to/parent.js\"]"],
        [2, "path_to_parent.js[\"path/to/parent.js\"]"]
      ]
    end

    with_them do
      it "return parent module name" do
        expect(nodes_link.parent_module_name(level)).to eq(expected)
      end
    end
  end

  describe "#child_module_name" do
    subject(:nodes_link) do
      described_class.new(parent, child)
    end

    let(:parent) { "path/to/parent.js" }
    let(:child) { "path/to/child.js" }

    where(:level, :expected) do
      [
        [nil, "path_to_child.js[\"path/to/child.js\"]"],
        [0, "path_to_child.js[\"child.js\"]"],
        [1, "path_to_child.js[\"to/child.js\"]"],
        [2, "path_to_child.js[\"path/to/child.js\"]"]
      ]
    end

    with_them do
      it "return child module name" do
        expect(nodes_link.child_module_name(level)).to eq(expected)
      end
    end
  end
end
