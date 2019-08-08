class AddMemberBeerPaymentTable < ActiveRecord::Migration[5.0]
  def change
    create_table :member_beer_payments do |t|
      t.references :members, index: true
      t.integer :amount
      t.string :changed_by

      t.timestamps
    end
  end
end
