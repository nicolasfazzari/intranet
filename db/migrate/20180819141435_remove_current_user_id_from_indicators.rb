class RemoveCurrentUserIdFromIndicators < ActiveRecord::Migration
  def change
    remove_column :indicators, :current_user_id, :integer
  end
end
