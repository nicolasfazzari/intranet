class AddCurrentUserIdToIndicators < ActiveRecord::Migration
  def change
    add_column :indicators, :current_user_id, :integer
  end
end
