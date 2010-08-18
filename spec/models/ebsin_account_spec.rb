require File.dirname(__FILE__) + '/../spec_helper'

describe EbsinAccount do
  before(:each) do
    @ebsin_account = EbsinAccount.new
  end

  it "should be valid" do
    @ebsin_account.should be_valid
  end
end
