require File.dirname(__FILE__) + '/../spec_helper'

describe EbsinCreditCard do
  before(:each) do
    @ebsin_credit_card = EbsinCreditCard.new
  end

  it "should be valid" do
    @ebsin_credit_card.should be_valid
  end
end
