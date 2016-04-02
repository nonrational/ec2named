require 'spec_helper'

describe Ec2named::InstanceAge do
  subject { Ec2named::InstanceAge.new(DateTime.parse("2014-04-08 11:21:32 -0400")) }

  before { Timecop.freeze(DateTime.parse("2016-05-18 20:11:22 -0400")) }
  after { Timecop.return }

  it "doesn't include nils in the time_diff components" do
    expect(subject.time_diff.values.any? { |v| v.nil? }).to be false
  end

  it "calculates age components" do
    expect(subject.time_diff).to eq({
      year: 2,
      month: 1,
      week: 1,
      day: 3,
      hour: 20,
      minute: 49,
      second: 50,
      diff: "2 years, 1 month, 1 week, 3 days and 20:49:50"
    })
  end

  it "provides helper methods for age components" do
    expect(subject.year).to eq 2
    expect(subject.month).to eq 1
    expect(subject.week).to eq 1
    expect(subject.day).to eq 3
    expect(subject.hour).to eq 20
    expect(subject.minute).to eq 49
    expect(subject.second).to eq 50
  end
end
