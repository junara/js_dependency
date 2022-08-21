# frozen_string_literal: true

require "rspec"

RSpec.describe JsDependency::Cli do
  describe "#version" do
    it "version command is existed" do
      expect { described_class.new.invoke(:version) }.not_to raise_error
    end

    it "output current version" do
      output = capture(:stdout) { described_class.start(%w[version]) }
      expect(output).to include(JsDependency::VERSION)
    end
  end

  describe "#orphan" do
    context "when src_path is not exist" do
      let(:options) do
        {}
      end

      it "parents command is raised" do
        expect do
          described_class.new.invoke(:orphan, [], options)
        end.to raise_error(TypeError)
      end
    end

    context "when src_path is exist" do
      let(:options) do
        {
          src_path: "spec/fixtures/index_creator/self_call/src",
          alias_paths: {}
        }
      end

      it "parents command is not raised" do
        expect do
          described_class.new.invoke(:orphan, [], options)
        end.not_to raise_error
      end
    end

    context "when cli command" do
      let(:expected_output) do
        <<~OUTPUT
          components/sub/Exclude.vue
          pages/app.js
          utils/calculation.js
        OUTPUT
      end

      it "return orphan list" do
        output = capture(:stdout) do
          described_class.start(%w[orphan -s spec/fixtures/index_creator/self_call/src -a @:pages])
        end
        expect(output).to eq(expected_output)
      end
    end
  end

  describe "#leave" do
    context "when src_path is not exist" do
      let(:options) do
        {}
      end

      it "parents command is raised" do
        expect do
          described_class.new.invoke(:leave, [], options)
        end.to raise_error(TypeError)
      end
    end

    context "when src_path is exist" do
      let(:options) do
        {
          src_path: "spec/fixtures/index_creator/self_call/src",
          alias_paths: {}
        }
      end

      it "parents command is not raised" do
        expect do
          described_class.new.invoke(:leave, [], options)
        end.not_to raise_error
      end
    end

    context "when cli command" do
      let(:expected_output) do
        <<~OUTPUT
          components/modal.js
          components/sub/Exclude.vue
          components/sub/Title.vue
        OUTPUT
      end

      it "return orphan list" do
        output = capture(:stdout) do
          described_class.start(%w[leave -s spec/fixtures/index_creator/self_call/src -a @:pages])
        end
        expect(output).to eq(expected_output)
      end
    end
  end

  describe "#parents" do
    context "when src_path is not exist" do
      let(:options) do
        {}
      end

      it "parents command is raised" do
        expect do
          described_class.new.invoke(:parents, [], options)
        end.to raise_error(TypeError)
      end
    end

    context "when src_path and target_path is exist" do
      let(:options) do
        {
          src_path: "spec/fixtures/index_creator/self_call/src",
          target_path: "spec/fixtures/index_creator/self_call/src/components/New",
          alias_paths: {}
        }
      end

      it "parents command is not raised" do
        expect do
          described_class.new.invoke(:parents, [], options)
        end.not_to raise_error
      end
    end

    context "when cli command with 1 level" do
      let(:expected_output) do
        <<~OUTPUT
          components/New.vue
        OUTPUT
      end

      it "return parents list" do
        output = capture(:stdout) do
          described_class.start(%w[parents -s spec/fixtures/index_creator/self_call/src -a @:pages -t
                                   spec/fixtures/index_creator/self_call/src/components/Button -p 1])
        end
        expect(output).to eq(expected_output)
      end
    end

    context "when cli command with 2 level" do
      let(:expected_output) do
        <<~OUTPUT
          components/New.vue
          pages/app.js
        OUTPUT
      end

      it "return parents list" do
        output = capture(:stdout) do
          described_class.start(%w[parents -s spec/fixtures/index_creator/self_call/src -a @:pages -t
                                   spec/fixtures/index_creator/self_call/src/components/Button -p 2])
        end
        expect(output).to eq(expected_output)
      end
    end
  end

  describe "#children" do
    context "when src_path is not exist" do
      let(:options) do
        {}
      end

      it "children command is raised" do
        expect do
          described_class.new.invoke(:children, [], options)
        end.to raise_error(TypeError)
      end
    end

    context "when src_path and target_path is exist" do
      let(:options) do
        {
          src_path: "spec/fixtures/index_creator/self_call/src",
          target_path: "spec/fixtures/index_creator/self_call/src/components/New",
          alias_paths: {}
        }
      end

      it "children command is not raised" do
        expect do
          described_class.new.invoke(:children, [], options)
        end.not_to raise_error
      end
    end

    context "when cli command with 1 level" do
      let(:expected_output) do
        <<~OUTPUT
          components/Button
          components/modal.js
        OUTPUT
      end

      it "return children list" do
        output = capture(:stdout) do
          described_class.start(%w[children -s spec/fixtures/index_creator/self_call/src -a @:pages -t
                                   spec/fixtures/index_creator/self_call/src/components/New.vue -c 1])
        end
        expect(output).to eq(expected_output)
      end
    end

    context "when cli command with 2 level" do
      let(:expected_output) do
        <<~OUTPUT
          components/Button
          components/modal.js
          components/sub/Title.vue
          fixtures/index_creator/self_call/src/components/sub/Exclude
        OUTPUT
      end

      it "return children list" do
        output = capture(:stdout) do
          described_class.start(%w[children -s spec/fixtures/index_creator/self_call/src -a @:pages -t
                                   spec/fixtures/index_creator/self_call/src/components/New.vue -c 2])
        end
        expect(output).to eq(expected_output)
      end
    end
  end

  describe "#export_mermaid" do
    context "when src_path is not exist" do
      let(:options) do
        {}
      end

      it "export_mermaid command is raised" do
        expect do
          described_class.new.invoke(:export_mermaid, [], options)
        end.to raise_error(TypeError)
      end
    end

    context "when src_path and target_path is exist" do
      let(:options) do
        {
          src_path: "spec/fixtures/index_creator/self_call/src",
          target_paths: ["spec/fixtures/index_creator/self_call/src/components/New"],
          alias_paths: {}
        }
      end

      it "export_mermaid command is not raised" do
        expect do
          described_class.new.invoke(:export_mermaid, [], options)
        end.not_to raise_error
      end
    end

    context "when cli command with 1 target_paths" do
      let(:expected_output) do
        <<~OUTPUT
          flowchart LR
          components_Button["components/Button"] --> components_sub_Title.vue["sub/Title.vue"]
          components_Button["components/Button"] --> fixtures_index_creator_self_call_src_components_sub_Exclude["sub/Exclude"]
          components_New.vue["components/New.vue"] --> components_Button["components/Button"]
          components_New.vue["components/New.vue"] --> components_modal.js["components/modal.js"]
          pages_app.js["pages/app.js"] --> components_New.vue["components/New.vue"]
          style components_New.vue stroke:#f9f,stroke-width:4px
        OUTPUT
      end

      it "return mermaid format text" do
        output = capture(:stdout) do
          described_class.start(%w[export_mermaid -s spec/fixtures/index_creator/self_call/src -a @:pages -t
                                   spec/fixtures/index_creator/self_call/src/components/New.vue])
        end
        expect(output).to eq(expected_output)
      end
    end

    context "when cli command with 2 target_paths" do
      let(:expected_output) do
        <<~OUTPUT
          flowchart LR
          components_Button["components/Button"] --> components_sub_Title.vue["sub/Title.vue"]
          components_Button["components/Button"] --> fixtures_index_creator_self_call_src_components_sub_Exclude["sub/Exclude"]
          components_New.vue["components/New.vue"] --> components_Button["components/Button"]
          components_New.vue["components/New.vue"] --> components_modal.js["components/modal.js"]
          pages_app.js["pages/app.js"] --> components_New.vue["components/New.vue"]
          utils_calculation.js["utils/calculation.js"] --> external_lib["external/lib"]
          style components_New.vue stroke:#f9f,stroke-width:4px
          style utils_calculation.js stroke:#f9f,stroke-width:4px
        OUTPUT
      end

      it "return mermaid format text" do
        output = capture(:stdout) do
          described_class.start(%w[export_mermaid -s spec/fixtures/index_creator/self_call/src -a @:pages -t
                                   spec/fixtures/index_creator/self_call/src/components/New.vue spec/fixtures/index_creator/self_call/src/utils/calculation.js])
        end
        expect(output).to eq(expected_output)
      end
    end
  end

  describe "#export_markdown_report" do
    context "when src_path is not exist" do
      let(:options) do
        {}
      end

      it "export_markdown_report command is raised" do
        expect do
          described_class.new.invoke(:export_markdown_report, [], options)
        end.to raise_error(TypeError)
      end
    end

    context "when src_path and target_path is exist" do
      let(:options) do
        {
          src_path: "spec/fixtures/index_creator/self_call/src",
          target_paths: ["spec/fixtures/index_creator/self_call/src/components/New"],
          alias_paths: {}
        }
      end

      it "export_markdown_report command is not raised" do
        expect do
          described_class.new.invoke(:export_markdown_report, [], options)
        end.not_to raise_error
      end
    end

    context "when cli command with 2 target_paths" do
      let(:expected_output) do
        <<~OUTPUT
          ## JsDependency Reports

          ### Orphan modules

          3 orphaned modules.

          * ``components/sub/Exclude.vue``
          * ``pages/app.js``
          * ``utils/calculation.js``

          ### Module dependency

          ```mermaid
          flowchart LR
          components_Button["components/Button"] --> components_sub_Title.vue["sub/Title.vue"]
          components_Button["components/Button"] --> fixtures_index_creator_self_call_src_components_sub_Exclude["sub/Exclude"]
          components_New.vue["components/New.vue"] --> components_Button["components/Button"]
          components_New.vue["components/New.vue"] --> components_modal.js["components/modal.js"]
          pages_app.js["pages/app.js"] --> components_New.vue["components/New.vue"]
          utils_calculation.js["utils/calculation.js"] --> external_lib["external/lib"]
          style components_New.vue stroke:#f9f,stroke-width:4px
          style utils_calculation.js stroke:#f9f,stroke-width:4px
          ```

          <!-- identifier -->
        OUTPUT
      end

      it "return markdown format text" do
        output = capture(:stdout) do
          described_class.start(%w[export_markdown_report -s spec/fixtures/index_creator/self_call/src -a @:pages -t
                                   spec/fixtures/index_creator/self_call/src/components/New.vue spec/fixtures/index_creator/self_call/src/utils/calculation.js --identifier identifier])
        end
        expect(output).to eq(expected_output)
      end
    end
  end
end
