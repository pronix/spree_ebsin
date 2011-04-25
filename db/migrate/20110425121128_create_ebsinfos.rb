class CreateEbsinfos < ActiveRecord::Migration
  def self.up
    create_table :ebsinfos do |t|
      t.string :first_name
      t.string :last_name
      t.string :TransactionId
      t.string :PaymentId

      t.timestamps
    end
  end

  def self.down
    drop_table :ebsinfos
  end
end
