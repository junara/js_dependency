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
        end.to raise_error
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
        end.to raise_error
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
        end.to raise_error
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
        end.to raise_error
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
end
