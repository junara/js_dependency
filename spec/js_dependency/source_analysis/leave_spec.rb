# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::SourceAnalysis::Leave do
  describe "self.call" do
    subject(:call) do
      index =
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
      src_path = "spec/fixtures/index_creator/self_call/src"
      described_class.new(index, src_path).call
    end

    let(:expected) do
      %w[components/modal.js components/sub/Exclude.vue components/sub/Title.vue]
    end

    it "returns index" do
      expect(call).to match_array(expected)
    end
  end
end
