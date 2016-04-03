require 'spec_helper'

require 'pry'

describe Ec2named::Instance do
  let(:raw_instance) { YAML.load(File.read("spec/fixtures/i-0a1b2c3d.yaml")).first }
  subject { Ec2named::Instance.new(raw_instance) }

  let(:default_config) { Ec2named::Config.new.load }
  let(:common_tags) { [%w(Name staging.sucksrocks), %w(app sucksrocks), %w(env staging)] }
  let(:tags) { common_tags + [['opsworks', 'did this']] }

  before do
    Ec2named.instance_variable_set(:@config, default_config)
  end

  it "#name" do
    expect(subject.send(:name)).to eq "staging.sucksrocks"
  end

  it "#status" do
    expect(subject.send(:status)).to eq nil
  end

  it "#tags" do
    expect(subject.send(:tags)).to match_array tags
  end

  it "#common_tags" do
    Ec2named.config["reject_tag_prefixes"] << "opsworks"
    expect(subject.send(:common_tags)).to match_array common_tags
  end
end
