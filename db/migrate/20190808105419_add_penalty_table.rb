class AddPenaltyTable < ActiveRecord::Migration[5.0]
  def change
    create_table :penalties do |t|
      t.string :penalty_name
      t.integer :penalty_cost
      t.integer :case_of_beer_cost

      t.timestamps
    end
  end
end
