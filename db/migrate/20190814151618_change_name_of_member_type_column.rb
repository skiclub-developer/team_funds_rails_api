class ChangeNameOfMemberTypeColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :members, :type, :member_type
  end
end
