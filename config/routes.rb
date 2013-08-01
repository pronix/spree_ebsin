Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :gateway do
    get '/:gateway_id/ebsin/:order_id' => 'ebsin#show',     :as => :ebsin
    get '/ebsin/:id/comeback'          => 'ebsin#comeback', :as => :ebsin_comeback
  end
end