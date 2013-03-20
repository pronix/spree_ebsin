#SpreeEbsin::Engine.routes.draw do
#Rails.application.routes.draw do
Spree::Core::Engine.routes.append do
  # Add your extension routes here
  namespace :gateway do
    match '/:gateway_id/ebsin/:order_id' => 'ebsin#show',     :as => :ebsin
    match '/ebsin/:id/comeback'          => 'ebsin#comeback', :as => :ebsin_comeback
  end
end
