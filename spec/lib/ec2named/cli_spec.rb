require 'spec_helper'

describe Ec2named::CLI do
  ARGV = [] # rubocop:disable Style/MutableConstant
  subject { Ec2named::CLI.new }
  let(:default_config) { Ec2named::Config.new.load }
  before { Ec2named.instance_variable_set(:@config, default_config) }

  it 'wildcards raw tag args correctly' do
    expect(subject.send(:underscores_are_wild, :tags, "git_commit:c95___,env:_dev_")).to eq("git_commit:c95*,env:*dev*")
  end

  it 'wildcards generic args correctly' do
    expect(subject.send(:underscores_are_wild, :foo, "we_are_your_friends__")).to eq("we*are*your*friends*")
  end
end
