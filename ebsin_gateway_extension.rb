# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class EbsinGatewayExtension < Spree::Extension
  version "1.0"
  description "Integration with EBS gateway."
  url "http://github.com/pronix/spree-ebsin"

  def activate

      PaymentMethod::Ebsin.register  

      # inject paypal code into orders controller
      CheckoutsController.class_eval do
        include Spree::Ebsin

        before_filter :redirect_for_ebsin
        before_filter :load_data, :except => [:payment_success, :payment_failure]
        def redirect_for_ebsin
          if object.payment? 
            if PaymentMethod.find(params[:checkout][:payments_attributes].first[:payment_method_id].to_i).class.name == 'PaymentMethod::Ebsin'
              payment_method = params[:checkout][:payments_attributes].first[:payment_method_id].to_i
              redirect_to(ebsin_payment_order_checkout_url(:payment_method_id => payment_method)) and return
            end
          end
        end
        
        def payment_success
          @order = Order.find_by_number(params[:order_id])
          session[:order_id] = nil
          flash[:commerce_tracking] = I18n.t("notice_messages.track_me_in_GA")
        end

      end

      Creditcard.class_eval do
        def process!(payment)
          return true
        end
      end

    end
  end
