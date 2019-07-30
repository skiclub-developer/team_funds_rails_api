class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.string :name
      t.integer :current_money_penalties
      t.integer :current_beer_penalties

      t.timestamps
    end
  end
end
