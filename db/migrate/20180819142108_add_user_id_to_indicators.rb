class AddUserIdToIndicators < ActiveRecord::Migration
  def change
    add_column :indicators, :user_id, :integer
    add_index :indicators, :user_id
  end
end
