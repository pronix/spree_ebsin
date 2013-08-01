class Ebsinfo < ActiveRecord::Base
<<<<<<< HEAD
  attr_accessible :first_name, :TransactionId, :PaymentId, :amount, :order_id
=======
  has_many :payments, :as => :source

  attr_accessible :first_name, :last_name, :TransactionId, :PaymentId
  def actions
    %w{mark_as_captured void}
  end
  
  # Indicates whether its possible to capture the payment
  def can_mark_as_captured?(payment)
    ['checkout', 'pending'].include?(payment.state)
  end
  
  # Indicates whether its possible to void the payment.
  def can_void?(payment)
    payment.state != 'void'
  end
  
  def mark_as_captured(payment)
    payment.update_attribute(:state, 'pending') if payment.state == 'checkout'
    payment.complete
    true
  end
  
  def void(payment)
    payment.update_attribute(:state, 'pending') if payment.state == 'checkout'
    payment.void
    true
  end

>>>>>>> 1c77a8bfc86b8f55a430d7f73044b80be505e063
end
