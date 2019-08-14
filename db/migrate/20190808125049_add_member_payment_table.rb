class AddMemberPaymentTable < ActiveRecord::Migration[5.0]
  def change
    create_table :member_payments do |t|
      t.belongs_to :member, index: true
      t.integer :amount
      t.string :changed_by

      t.timestamps
    end
  end
end
