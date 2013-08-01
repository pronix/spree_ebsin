module Spree
  class Ebsinfo < ActiveRecord::Base
    attr_accessible :first_name, :TransactionId, :PaymentId, :amount, :order_id
    self.table_name = :ebsinfos
  end
end
