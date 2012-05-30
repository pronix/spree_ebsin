class PaymentMethod::Ebsin < Spree::PaymentMethod

  preference :account_id, :string
  preference :url,        :string, :default =>  "https://secure.ebs.in/pg/ma/sale/pay/"
  preference :secret_key, :string
  preference :mode, :string
  preference :currency_code, :string

  def payment_profiles_supported?
    false
  end

end
