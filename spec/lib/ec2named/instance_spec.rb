require 'spec_helper'

require 'pry'

describe Ec2named::Instance do
  let(:raw_instance) { YAML.load(File.read("spec/fixtures/i-0a1b2c3d.yaml")).first }
  subject { Ec2named::Instance.new(raw_instance) }

  it "#name" do
    expect(subject.send(:name)).to eq "staging.sucksrocks"
  end

  it "#status" do
    expect(subject.send(:status)).to eq nil
  end

  it "#tags" do
    expect(subject.send(:tags)).to match_array([
      ["Name", "staging.sucksrocks"],
      ["app", "sucksrocks"],
      ["env", "staging"]
    ])
  end

  it "#common_tags" do
    expect(subject.send(:common_tags)).to match_array([
      ["Name", "staging.sucksrocks"],
      ["app", "sucksrocks"],
      ["env", "staging"]
    ])
  end
end
