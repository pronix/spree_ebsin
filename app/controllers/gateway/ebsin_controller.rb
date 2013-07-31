require 'base64'
require 'digest/md5'
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
    @order   = Spree::Order.find(params[:order_id])
    @gateway = @order.available_payment_methods.find{|x| x.id == params[:gateway_id].to_i }
    @order.payments.destroy_all
    @hash = Digest::MD5.hexdigest(@gateway.preferred_secret_key+"|"+@gateway.preferred_account_id+"|"+@order.total.to_s+"|"+@order.number+"|"+[gateway_ebsin_comeback_url(@order),'DR={DR}'].join('?')+"|"+@gateway.preferred_mode)
    payment = @order.payments.create!(:amount => 0,  :payment_method_id => @gateway.id)

    if @order.blank? || @gateway.blank?
      flash[:error] = I18n.t("invalid_arguments")
      redirect_to :back
    else
      @bill_address, @ship_address =  @order.bill_address, (@order.ship_address || @order.bill_address)
      render :action => :show, :layout => false
    end
  end

  # Result from EBS
  #
  def comeback
    @order   = Spree::Order.find_by_number(params[:id])
    @gateway = @order && @order.payments.first.payment_method
    if @gateway && @gateway.kind_of?(Spree::PaymentMethod::Ebsin) && params[:DR] &&
        (@data = ebsin_decode(params[:DR], @gateway.preferred_secret_key)) &&
        (@data["ResponseMessage"] == "Transaction Successful")
      @order.next
      if @order.store_credit_id
        credit_used = @order.store_credit_amount
        credit = @order.store_credit
        if credit
          credit.remaining_amount -= credit_used
          credit.save
        end
      end
      #log the transaction
      Spree::Ebsinfo.create(:first_name => @order.bill_address.firstname, :TransactionId => @data["TransactionID"], :PaymentId => @data["PaymentID"], :amount => @data["Amount"], :order_id => @order.id)
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

end
