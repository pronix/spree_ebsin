Spree::CheckoutController.class_eval do

  before_filter :redirect_for_ebsin, :only => :update

  private

  def redirect_for_ebsin
    return unless params[:state] == "payment"
    @payment_method = PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
    if @payment_method && @payment_method.kind_of?(PaymentMethod::Ebsin)
      @order.update_attributes(object_params)
      redirect_to gateway_ebsin_path(:gateway_id => @payment_method.id, :order_id => @order.id)
    end
  end

end
