# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::IndexCreator do
  describe "self.call" do
    subject(:call) do
      src = "spec/fixtures/index_creator/self_call/src"
      alias_paths = { "@" => "./pages" }
      excludes = ["Exclude"]
      described_class.call(
        src,
        alias_paths: alias_paths,
        excludes: excludes
      )
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
end
