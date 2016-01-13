require 'spec_helper'

describe IO do
  it "responds to print_flush" do
    expect(STDERR).to respond_to :print_flush
    expect(STDOUT).to respond_to :print_flush
  end
end
