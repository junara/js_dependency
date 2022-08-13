# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::Mermaid::TargetPathname do
  describe "#initialize" do
    context "when target_path is nil" do
      it "raises TypeError" do
        expect { described_class.new(nil) }.to raise_error(TypeError)
      end
    end

    context "when target_path is String" do
      it "does not raise error" do
        expect do
          described_class.new("spec/fixtures/mermaid/target_pathname/src/pages/target_path.js")
        end.not_to raise_error
      end
    end
  end

  describe "#mermaid_style" do
    context "when srt_path is existed" do
      subject(:target_pathname) do
        described_class.new("spec/fixtures/mermaid/target_pathname/src/pages/target_path.js")
      end

      it "returns src style" do
        expect(target_pathname.mermaid_style("spec/fixtures/mermaid/target_pathname/src")).to eq("style pages_target_path.js stroke:#f9f,stroke-width:4px")
      end

      it "returns src/pages style" do
        expect(target_pathname.mermaid_style("spec/fixtures/mermaid/target_pathname/src/pages")).to eq("style target_path.js stroke:#f9f,stroke-width:4px")
      end
    end

    context "when src_path is not existed" do
      subject(:target_pathname) do
        described_class.new("spec/fixtures/mermaid/target_pathname/src/pages/target_path.js")
      end

      let(:src_path) { "not/existed" }

      it "raise Errno::ENOENT error" do
        expect { target_pathname.mermaid_style(src_path) }.to raise_error(Errno::ENOENT)
      end
    end

    context "when target_pathname is not existed" do
      subject(:target_pathname) { described_class.new("external/library") }

      let(:src_path) { "spec/fixtures/mermaid/target_pathname/src" }

      it "returns style" do
        expect(target_pathname.mermaid_style(src_path)).to eq("style external_library stroke:#f9f,stroke-width:4px")
      end
    end
  end
end
