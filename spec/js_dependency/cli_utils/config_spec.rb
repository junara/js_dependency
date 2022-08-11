# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::CliUtils::Config do
  describe "#initialize" do
    context "when assuming export_mermaid command with only args" do
      subject(:config) { described_class.new(options, args) }

      let(:args) do
        {
          src_path: "./src",
          target_path: ["./src/App.vue"],
          output_path: "./mermaid.txt",
          child_analyze_level: 2,
          parent_analyze_level: 2,
          name_level: 1,
          excludes: %w[excludedWord1 excludedWord2],
          alias_paths: { "@" => "./pages" }
        }
      end
      let(:options) { {} }

      it { expect(config.src_path).to eq("./src") }
      it { expect(config.target_paths).to eq(["./src/App.vue"]) }
      it { expect(config.output_path).to eq("./mermaid.txt") }
      it { expect(config.child_analyze_level).to eq(2) }
      it { expect(config.parent_analyze_level).to eq(2) }
      it { expect(config.name_level).to eq(1) }
      it { expect(config.excludes).to eq(%w[excludedWord1 excludedWord2]) }
      it { expect(config.alias_paths).to eq({ "@" => "./pages" }) }
    end

    context "when assuming export_mermaid command with options and args" do
      subject(:config) { described_class.new(options, args) }

      let(:args) do
        {
          src_path: "./src",
          target_paths: ["./src/App.vue"],
          output_path: "./mermaid.txt",
          child_analyze_level: 2,
          parent_analyze_level: 2,
          name_level: 1,
          excludes: %w[excludedWord1 excludedWord2],
          alias_paths: { "@" => "./pages" }
        }
      end
      let(:options) do
        {
          target_paths: %w[./src/App.vue ./src/Other.vue]
        }
      end

      it { expect(config.target_paths).to eq(%w[./src/App.vue ./src/Other.vue]) }
    end

    context "when assuming parents or children command with options and args" do
      subject(:config) { described_class.new(options, args) }

      let(:args) do
        {
          src_path: "./src",
          target_paths: ["./src/App.vue"],
          output_path: "./mermaid.txt",
          child_analyze_level: 2,
          parent_analyze_level: 2,
          name_level: 1,
          excludes: %w[excludedWord1 excludedWord2],
          alias_paths: { "@" => "./pages" }
        }
      end
      let(:options) do
        {
          target_path: "./src/App.vue"
        }
      end

      it { expect(config.target_path).to eq("./src/App.vue") }
    end
  end
end
