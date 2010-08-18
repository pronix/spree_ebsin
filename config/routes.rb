# Put your extension routes here.

# map.namespace :admin do |admin|
#   admin.resources :whatever
# end  

map.resources :orders do |order|
  order.resource :checkout, :member => {:ebsin_payment => :any, :payment_failure => :any, :payment_success => :any}
end

# 
# map.resources :paypal_express_callbacks, :only => [:index]
# 
# map.namespace :admin do |admin|
#   admin.resources :orders do |order|
#     order.resources :paypal_payments, :member => {:capture => :get, :refund => :any}, :has_many => [:txns]
#   end
# end
