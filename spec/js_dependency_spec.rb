# frozen_string_literal: true

RSpec.describe JsDependency do
  describe "self.export_index" do
    subject(:call) do
      src = "spec/fixtures/index_creator/self_call/src"
      alias_paths = { "@" => "./pages" }
      excludes = ["Exclude"]
      described_class.export_index(src, alias_paths: alias_paths, excludes: excludes)
    end

    let(:expected) do
      {
        Pathname.new("spec/fixtures/index_creator/self_call/src/components/Button").realpath.to_s => [
          Pathname.new("spec/fixtures/index_creator/self_call/src/components/sub/Title.vue").realpath.to_s
        ],
        Pathname.new("spec/fixtures/index_creator/self_call/src/components/Button/index.js").realpath.to_s => [
          Pathname.new("spec/fixtures/index_creator/self_call/src/components/sub/Title.vue").realpath.to_s
        ],
        Pathname.new("spec/fixtures/index_creator/self_call/src/components/New.vue").realpath.to_s => [
          Pathname.new("spec/fixtures/index_creator/self_call/src/components/Button").realpath.to_s,
          Pathname.new("spec/fixtures/index_creator/self_call/src/components/modal.js").realpath.to_s
        ],
        Pathname.new("spec/fixtures/index_creator/self_call/src/components/modal.js").realpath.to_s => [],
        Pathname.new("spec/fixtures/index_creator/self_call/src/components/sub/Title.vue").realpath.to_s => [],
        Pathname.new("spec/fixtures/index_creator/self_call/src/pages/app.js").realpath.to_s => [
          Pathname.new("spec/fixtures/index_creator/self_call/src/components/New.vue").realpath.to_s
        ],
        Pathname.new("spec/fixtures/index_creator/self_call/src/utils/calculation.js").realpath.to_s => ["external/lib"],
        Pathname.new("spec/fixtures/index_creator/self_call/src/components/sub/Exclude.vue").realpath.to_s => []
      }
    end

    it "returns index" do
      expect(call).to eq(expected)
    end
  end

  describe "self.leave" do
    subject(:call) do
      src_path = "spec/fixtures/index_creator/self_call/src"
      described_class.leave(src_path, alias_paths: nil)
    end

    let(:expected) do
      %w[components/modal.js components/sub/Exclude.vue components/sub/Title.vue]
    end

    it "returns index" do
      expect(call).to contain_exactly(*expected)
    end
  end

  describe "self.orphan" do
    subject(:call) do
      src_path = "spec/fixtures/index_creator/self_call/src"
      described_class.orphan(src_path, alias_paths: nil)
    end

    let(:expected) do
      %w[components/sub/Exclude.vue components/sub/Title.vue pages/app.js utils/calculation.js]
    end

    it "returns index" do
      expect(call).to contain_exactly(*expected)
    end
  end

  describe "self.export_mermaid" do
    subject(:call) do
      src_path = "spec/fixtures/index_creator/self_call/src"
      alias_paths = { "@" => "./pages" }
      excludes = ["Exclude"]
      target_paths = [
        "spec/fixtures/index_creator/self_call/src/components/New.vue"
      ]
      described_class.export_mermaid(
        src_path,
        target_paths,
        orientation: "LR",
        alias_paths: alias_paths,
        child_analyze_level: 1,
        parent_analyze_level: 1,
        name_level: 1,
        output_path: nil,
        excludes: excludes
      )
    end

    let(:expected) do
      <<~STR
        flowchart LR
        components_New.vue["components/New.vue"] --> components_Button["components/Button"]
        components_New.vue["components/New.vue"] --> components_modal.js["components/modal.js"]
        pages_app.js["pages/app.js"] --> components_New.vue["components/New.vue"]
        style components_New.vue stroke:#f9f,stroke-width:4px
      STR
    end

    it "returns index" do
      expect(call).to eq(expected)
    end
  end

  describe "self.parents" do
    subject(:call) do
      src_path = "spec/fixtures/index_creator/self_call/src"
      alias_paths = { "@" => "./pages" }
      excludes = ["Exclude"]
      target_path = "spec/fixtures/index_creator/self_call/src/components/New.vue"
      described_class.parents(
        src_path,
        target_path,
        alias_paths: alias_paths,
        parent_analyze_level: 1,
        output_path: nil,
        excludes: excludes
      )
    end

    let(:expected) do
      ["pages/app.js"]
    end

    it "returns index" do
      expect(call).to eq(expected)
    end
  end

  describe "self.children" do
    subject(:call) do
      src_path = "spec/fixtures/index_creator/self_call/src"
      alias_paths = { "@" => "./pages" }
      excludes = ["Exclude"]
      target_path = "spec/fixtures/index_creator/self_call/src/components/New.vue"
      described_class.children(
        src_path,
        target_path,
        alias_paths: alias_paths,
        child_analyze_level: 1,
        output_path: nil,
        excludes: excludes
      )
    end

    let(:expected) do
      %w[components/Button components/modal.js]
    end

    it "returns index" do
      expect(call).to eq(expected)
    end
  end
end
