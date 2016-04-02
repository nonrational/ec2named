require 'spec_helper'

require 'pry'

describe Ec2named::Instance do
  let(:raw_instance) { YAML.load(File.read("spec/fixtures/i-0a1b2c3d.yaml")).first }
  subject { Ec2named::Instance.new(raw_instance) }

  it "#common_tags" do
    expect(subject.send(:common_tags)).to match_array([
      ["Name", "stage.pipeline.sucksrocks"],
      ["app", "sucksrocks"],
      ["env", "stage"],
      ["status", "in-use"]
    ])
  end
end
