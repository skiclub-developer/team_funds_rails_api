class AddMemberPenaltyTable < ActiveRecord::Migration[5.0]
  def change
    create_table :member_penalties do |t|
      t.references :members, index: true, foreign_key: true
      t.references :penalties, index: true, foreign_key: true
      t.integer :amount
      t.string :changed_by

      t.timestamps
    end
  end
end
