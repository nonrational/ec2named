require 'spec_helper'

describe Ec2named::InstanceAge do
  subject { Ec2named::InstanceAge.new(DateTime.parse("2014-04-08 11:20:11 -0400")) }

  before { Timecop.freeze(DateTime.parse("2016-04-18 11:24:14 -0400")) }
  after { Timecop.return }

  it "calculates age components" do
    expect(subject.time_diff).to eq({
      year: 2,
      month: 0,
      week: 1,
      day: 3,
      hour: 12,
      minute: 4,
      second: 3,
      diff: "2 years, 1 week, 3 days and 12:04:03"
    })
  end

  it "displays like a stopwatch with years/months/weeks as days" do
    expect(subject.to_s).to eq "740:12:04:03"
  end

  it "#ymw_day" do
    expect(subject.ymw_day).to eq 740
  end

  it "provides helper methods for age components" do
    expect(subject.year).to eq 2
    expect(subject.month).to eq 0
    expect(subject.week).to eq 1
    expect(subject.day).to eq 3
    expect(subject.hour).to eq 12
    expect(subject.minute).to eq 4
    expect(subject.second).to eq 3
  end
end
