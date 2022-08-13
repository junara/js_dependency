# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::CliUtils::Yaml do
  describe "#initialize" do
    context "when only path" do
      it "not raises JsDependency::Error" do
        expect do
          described_class.new(path: "path")
        end.not_to raise_error
      end
    end

    context "when only dir_path" do
      it "not raises JsDependency::Error" do
        expect do
          described_class.new(dir_path: "dir_path")
        end.not_to raise_error
      end
    end
  end

  describe "#args" do
    context "when .js_dependency_yaml" do
      it "read as hash with symbolized key" do
        dir_path = "spec/fixtures/js_dependency_yaml/yaml"
        expect(described_class.new(dir_path: dir_path).args).to eq(
          { alias_paths: { "@" => "./pages" }, child_analyze_level: 2, excludes: %w[excludedWord1 excludedWord2], name_level: 1,
            output_path: "./mermaid.txt", parent_analyze_level: 2, src_path: "./src", target_path: "./src/App.vue" }
        )
      end
    end

    context "when.js_dependency_yml" do
      it "read as hash with symbolized key" do
        dir_path = "spec/fixtures/js_dependency_yaml/yml"
        expect(described_class.new(dir_path: dir_path).args).to eq(
          { alias_paths: { "@" => "./pages" }, child_analyze_level: 2, excludes: %w[excludedWord1 excludedWord2], name_level: 1,
            output_path: "./mermaid.txt", parent_analyze_level: 2, src_path: "./src", target_path: "./src/App.vue" }
        )
      end
    end

    context "when none of config file" do
      it "return blank hash" do
        dir_path = "spec/fixtures/js_dependency_yaml/none"
        expect(described_class.new(dir_path: dir_path).args).to eq({})
      end
    end

    context "when path is specified" do
      it "return blank hash" do
        path = "spec/fixtures/js_dependency_yaml/path_configured/path.yml"
        expect(described_class.new(path: path).args).to eq(
          { alias_paths: { "@" => "./pages" }, child_analyze_level: 2, excludes: %w[excludedWord1 excludedWord2], name_level: 1,
            output_path: "./mermaid.txt", parent_analyze_level: 2, src_path: "./src", target_path: "./src/App.vue" }
        )
      end
    end
  end

  describe "#dir_path" do
    context "when nil" do
      it "return current directory" do
        expect(described_class.new(dir_path: nil).dir_path).to eq(Dir.pwd)
      end
    end

    context "when none" do
      it "return current directory" do
        expect(described_class.new.dir_path).to eq(Dir.pwd)
      end
    end
  end

  describe "#path" do
    context "when nil" do
      it "return current directory" do
        expect(described_class.new(dir_path: nil).dir_path).to eq(Dir.pwd)
      end
    end

    context "when path string" do
      it "return current directory" do
        expect(described_class.new.dir_path).to eq(Dir.pwd)
      end
    end
  end
end
