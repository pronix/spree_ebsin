require File.dirname(__FILE__) + '/../../spec_helper'

describe Gateway::Ebsin do
  before(:each) do
    @ebsin = Gateway::Ebsin.new
  end

  it "should be valid" do
    @ebsin.should be_valid
  end
end
