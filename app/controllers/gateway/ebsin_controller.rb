require 'base64'
class Gateway::EbsinController < Spree::BaseController
  include ERB::Util
  skip_before_filter :verify_authenticity_token, :only => [:comeback]

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


  # Show form EBS for pay
  #
  def show
    @order   = Order.find(params[:order_id])
    @gateway = @order.available_payment_methods.find{|x| x.id == params[:gateway_id].to_i }
    @order.payments.destroy_all
    payment = @order.payments.create!(:amount => 0,  :payment_method_id => @gateway.id)

    if @order.blank? || @gateway.blank?
      flash[:error] = I18n.t("invalid_arguments")
      redirect_to :back
    else
      @bill_address, @ship_address =  @order.bill_address, (@order.ship_address || @order.bill_address)
      render :action => :show
    end
  end

  # Result from EBS
  #
  def comeback
    @order   = Order.find_by_number(params[:id])
    @gateway = @order && @order.payments.first.payment_method

    if @gateway && @gateway.kind_of?(PaymentMethod::Ebsin) && params[:DR] &&
        (@data = ebsin_decode(params[:DR], @gateway.preferred_secret_key)) &&
        (@data["ResponseMessage"] == "Transaction Successful")

      ebsin_payment_success(@data)
      @order.checkout.next
      @order.save
      session[:order_id] = nil
      redirect_to order_url(@order, {:checkout_complete => true, :order_token => @order.token}), :notice => I18n.t("payment_success")
    else
      flash[:error] = I18n.t("ebsin_payment_response_error")
      redirect_to (@order.blank? ? root_url : edit_order_url(@order))
    end

  end


  private

  # processing geteway returned data
  #
  def ebsin_decode(data, key)
    rc4 = RubyRc4.new(key)
    (Hash[ rc4.encrypt(Base64.decode64(data.gsub(/ /,'+'))).split('&').map { |x| x.split("=") } ]).slice(* NECESSARY )
  end

  # Completed payment process
  #
  def ebsin_payment_success(data)
    # record the payment
    fake_card = Creditcard.new({ :cc_type => "visa", :month => Time.now.month, :year => Time.now.year,
                                 :first_name          => @order.bill_address.firstname,
                                 :last_name           => @order.bill_address.lastname,
                                 :verification_value  => data["TransactionID"],
                                 :number              => data["PaymentID"] })

    payment = @order.checkout.payments.create({ :amount => @order.total, :source => fake_card, :payment_method_id => @gateway.id})

    # query - need 0 in amount for an auth? see main code
    transaction = CreditcardTxn.new({ :amount => @order.total,
                                      :response_code => 'success',
                                      :txn_type => CreditcardTxn::TxnType::PURCHASE })
    payment.txns << transaction
    payment.finalize!
  end

end
