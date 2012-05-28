class Ebsinfo < ActiveRecord::Base

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

end
