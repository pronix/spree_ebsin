# Put your extension routes here.

# map.namespace :admin do |admin|
#   admin.resources :whatever
# end  

map.resources :orders do |order|
  order.resource :checkout, :member => {:ebsin_payment => :any, :ebsin_comeback => :any}
end

