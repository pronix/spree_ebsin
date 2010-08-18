module Spree::Ebsin
  include ERB::Util
  # include ActiveMerchant::RequiresParameters

  def ebsin_payment
    load_object
    @gateway = payment_method
  end
  
  def payment_success
    load_object
    @gateway = payment_method
  end

  def payment_failure
    load_object
    @gateway = payment_method
  end

  # create the gateway from the supplied options
  def payment_method
    PaymentMethod.find(params[:payment_method_id])
  end
  
end
