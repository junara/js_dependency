# frozen_string_literal: true

RSpec.describe JsDependency do
  it "has a version number" do
    expect(JsDependency::VERSION).not_to be_nil
  end
end
