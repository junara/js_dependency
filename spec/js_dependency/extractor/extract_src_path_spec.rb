# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::Extractor::ExtractSrcPath do
  describe "self.call" do
    context "when single line and JavaScript file" do
      where(:str, :expected) do
        [
          ['<script src="module-name.js">', ["module-name.js"]],
          ['<script src="module-name.js">', ["module-name.js"]],
          ['<script        src="module-name.js">', ["module-name.js"]],
          ["<script src='module-name.js'>", ["module-name.js"]],
          ["<script src='module-name.js'>", ["module-name.js"]]
        ]
      end

      with_them do
        it "returns an array of paths" do
          expect(described_class.call(str)).to eq(expected)
        end
      end
    end

    context "when not JavaScript" do
      where(:str, :expected) do
        [
          ["<script>", []],
          ['<script src="css-name.css">', []]
        ]
      end

      with_them do
        it "returns an array of paths" do
          expect(described_class.call(str)).to eq(expected)
        end
      end
    end

    context "with line brake" do
      let(:str) do
        <<~STR
          <script
            src="module-name.js">
        STR
      end

      it "returns an array of paths" do
        expect(described_class.call(str)).to eq(["module-name.js"])
      end
    end
  end
end
