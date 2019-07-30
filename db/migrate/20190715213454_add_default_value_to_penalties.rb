class AddDefaultValueToPenalties < ActiveRecord::Migration[5.0]
  def change
    change_column :members, :current_beer_penalties, :integer, :default => 0
    change_column :members, :current_money_penalties, :integer, :default => 0
  end
end
