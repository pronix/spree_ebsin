# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class EbsinGatewayExtension < Spree::Extension
  version "1.0"
  description "Integration with EBS gateway."
  url "http://github.com/pronix/spree-ebsin"

  def activate

      PaymentMethod::Ebsin.register  

      # inject payment_metod code into orders controller
      CheckoutsController.class_eval do
        include Spree::Ebsin

        before_filter :redirect_for_ebsin
        before_filter :load_data #, :except => [:ebsin_comeback]
        
        def redirect_for_ebsin
          if object.payment? 
            if PaymentMethod.find(params[:checkout][:payments_attributes].first[:payment_method_id].to_i).class.name == 'PaymentMethod::Ebsin'
              payment_method = params[:checkout][:payments_attributes].first[:payment_method_id].to_i
              redirect_to(ebsin_payment_order_checkout_url(:payment_method_id => payment_method)) and return
            end
          end
        end
        
        # Retun point after pay
        def ebsin_comeback
          if payment_method.class.name == 'PaymentMethod::Ebsin' && params[:DR] && 
             (data = ebsin_decode(params[:DR], payment_method.preferred_secret_key)) &&
              data["ResponseMessage"]=="Transaction Successful"
            # TODO compare order amout && response data amount must be eq
            
            # Write log; TODO RAILS_ROOT/log/ebs_success.log
            logger.add(0 , " EBS payment authorized on order #{@order.number} ".center(78,'*'))
            data.each {|x,y| logger.add(0, [x.ljust(15),y.ljust(25)].join(' = ').center(78))}
            logger.add(0 ,'*' * 78)
            # finalize payment
            ebsin_payment_success(data)
            # complete checkout
            @order.checkout.next
            # save order; TODO really need?
            @order.save
            session[:order_id] = nil
            # redirect to order complete
            redirect_to order_url(@order, {:checkout_complete => true, :order_token => @order.token})
          else
            flash[:error] = I18n.t("ebsin_payment_response_error")
            redirect_to edit_order_url(@order)
          end
        end
      end

      Creditcard.class_eval do
        def process!(payment)
          return true
        end
      end

    end
  end
