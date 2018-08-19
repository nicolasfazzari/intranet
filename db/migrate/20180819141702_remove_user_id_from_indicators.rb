class RemoveUserIdFromIndicators < ActiveRecord::Migration
  def change
    remove_column :indicators, :user_id, :integer
  end
end
