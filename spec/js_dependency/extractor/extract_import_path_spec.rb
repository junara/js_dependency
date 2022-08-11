# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::Extractor::ExtractImportPath do
  describe "self.call" do
    context "when double quote" do
      where(:str, :expected) do
        [
          ['import defaultExport from "module-name";', ["module-name"]],
          ['import * as name from "module-name";', ["module-name"]],
          ['import { export1 } from "module-name";', ["module-name"]],
          ['import { export1 as alias1 } from "module-name";', ["module-name"]],
          ['import { export1 , export2 } from "module-name";', ["module-name"]],
          ['import { foo , bar } from "module-name/path/to/specific/un-exported/file";',
           ["module-name/path/to/specific/un-exported/file"]],
          ['import { export1 , export2 as alias2 , [...] } from "module-name";', ["module-name"]],
          ['import defaultExport, { export1 [ , [...] ] } from "module-name";', ["module-name"]],
          ['import defaultExport, * as name from "module-name";', ["module-name"]],
          ['import "module-name";', ["module-name"]],
          ['var promise = import("module-name");', ["module-name"]]
        ]
      end

      with_them do
        it "returns an array of paths" do
          expect(described_class.call(str)).to eq(expected)
        end
      end
    end

    context "when single quote" do
      where(:str, :expected) do
        [
          ["import defaultExport from 'module-name';", ["module-name"]],
          ["import * as name from 'module-name';", ["module-name"]],
          ["import { export1 } from 'module-name';", ["module-name"]],
          ["import { export1 as alias1 } from 'module-name';", ["module-name"]],
          ["import { export1 , export2 } from 'module-name';", ["module-name"]],
          ["import { foo , bar } from 'module-name/path/to/specific/un-exported/file';",
           ["module-name/path/to/specific/un-exported/file"]],
          ["import { export1 , export2 as alias2 , [...] } from 'module-name';", ["module-name"]],
          ["import defaultExport, { export1 [ , [...] ] } from 'module-name';", ["module-name"]],
          ["import defaultExport, * as name from 'module-name';", ["module-name"]],
          ["import 'module-name';", ["module-name"]],
          ["var promise = import('module-name');", ["module-name"]]
        ]
      end

      with_them do
        it "returns an array of paths" do
          expect(described_class.call(str)).to eq(expected)
        end
      end
    end

    context "with new line" do
      let(:str) do
        <<~STR
          import {
            foo,
          } from 'module-name';
        STR
      end

      it "returns an array of paths" do
        expect(described_class.call(str)).to eq(["module-name"])
      end
    end

    context "with other code and single quotation" do
      let(:str) do
        <<~STR
          console.log("fuga");
          import {
            foo,
          } from 'module-name';
          console.log("hello");
        STR
      end

      it "returns an array of paths" do
        expect(described_class.call(str)).to eq(["module-name"])
      end
    end

    context "with other code and double quotation" do
      let(:str) do
        <<~STR
          console.log("fuga");
          import {
            foo,
          } from "module-name";
          console.log("hello");
        STR
      end

      it "returns an array of paths" do
        expect(described_class.call(str)).to eq(["module-name"])
      end
    end
  end
end
