# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::PathnameUtility do
  describe "#complement_extname" do
    context "when external module directory" do
      let(:pathname) { Pathname.new("/path/to/module") }

      it "not changed" do
        expect(described_class.complement_extname(pathname)).to eq(pathname)
      end
    end

    context "when external module file" do
      let(:pathname) { Pathname.new("/path/to/module/lib.js") }

      it "not changed" do
        expect(described_class.complement_extname(pathname)).to eq(pathname)
      end
    end

    context "when existed file" do
      let(:pathname) { Pathname.new("spec/fixtures/pathname_utility/existed_file.js") }

      it "not changed" do
        expect(described_class.complement_extname(pathname)).to eq(pathname)
      end
    end

    context "when existed basename.js" do
      let(:pathname) { Pathname.new("spec/fixtures/pathname_utility/js") }

      it ".js file pathname" do
        expect(described_class.complement_extname(pathname)).to eq(Pathname.new("spec/fixtures/pathname_utility/js.js"))
      end
    end

    context "when existed basename.vue" do
      let(:pathname) { Pathname.new("spec/fixtures/pathname_utility/vue") }

      it ".vue file pathname" do
        expect(described_class.complement_extname(pathname)).to eq(Pathname.new("spec/fixtures/pathname_utility/vue.vue"))
      end
    end

    context "when existed basename.jsx" do
      let(:pathname) { Pathname.new("spec/fixtures/pathname_utility/jsx") }

      it ".vue file pathname" do
        expect(described_class.complement_extname(pathname)).to eq(Pathname.new("spec/fixtures/pathname_utility/jsx.jsx"))
      end
    end
  end

  describe "#to_target_pathname" do
    context "when existed relative path" do
      let(:target_path) { "spec/fixtures/src" }

      it "return realpath pathname" do
        expect(described_class.to_target_pathname(target_path)).to eq(Pathname.new(target_path).realpath)
      end
    end

    context "when existed absolute path" do
      let(:target_path) { Pathname.new("spec/fixtures/src").realpath.to_s }

      it "return realpath pathname" do
        expect(described_class.to_target_pathname(target_path)).to eq(Pathname.new(target_path).realpath)
      end
    end

    context "when not existed absolute path" do
      let(:target_path) { "spec/fixtures/xxx_src" }

      it "return realpath pathname" do
        expect(described_class.to_target_pathname(target_path)).to eq(Pathname.new(target_path))
      end
    end
  end
end
