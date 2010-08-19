module Spree::Ebsin

  include ERB::Util
  require 'base64'
  
  def ebsin_payment
    load_object
    @gateway = payment_method
  end
  
  # create the gateway from the supplied options
  def payment_method
    PaymentMethod.find(params[:payment_method_id])
  end

  # fields wich need to process
  NECESSARY = [
    "Mode",
    "PaymentID",
    "DateCreated",
    "MerchantRefNo",
    "Amount",
    "TransactionID",
    "ResponseCode",
    "ResponseMessage"
  ]

  # processing geteway returned data
  def ebsin_decode(data, key)
    rc4 = RubyRc4.new(key)
    (Hash[ rc4.encrypt(Base64.decode64(data.gsub(/ /,'+'))).split('&').map { |x| x.split("=") } ]).slice(* NECESSARY )
  end
  
  def ebsin_payment_success(data)
    load_object
    @gateway = payment_method

    # record the payment
    fake_card = Creditcard.new :cc_type        => "visa",
                               :month          => Time.now.month, 
                               :year           => Time.now.year, 
                               :first_name     => @order.bill_address.firstname, 
                               :last_name      => @order.bill_address.lastname,
                               :verification_value => data["TransactionID"],
                               :number => data["PaymentID"]

    payment = @order.checkout.payments.create(:amount => @order.total, 
                                              :source => fake_card,
                                              :payment_method_id => @gateway.id)

    # query - need 0 in amount for an auth? see main code
    transaction = CreditcardTxn.new( :amount => @order.total,
                                     :response_code => 'success',
                                   # :payment_status => 'paid',
                                     :txn_type => CreditcardTxn::TxnType::PURCHASE)
    payment.txns << transaction  
    payment.finalize!
    
  end

end
