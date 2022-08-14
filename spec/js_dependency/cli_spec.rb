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
end
