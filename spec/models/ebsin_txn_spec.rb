require File.dirname(__FILE__) + '/../spec_helper'

describe EbsinTxn do
  before(:each) do
    @ebsin_txn = EbsinTxn.new
  end

  it "should be valid" do
    @ebsin_txn.should be_valid
  end
end
