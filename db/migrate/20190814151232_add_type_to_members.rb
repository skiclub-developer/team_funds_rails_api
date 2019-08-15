class AddTypeToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :type, :integer
  end
end
