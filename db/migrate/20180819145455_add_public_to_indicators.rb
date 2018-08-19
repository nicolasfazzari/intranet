class AddPublicToIndicators < ActiveRecord::Migration
  def change
    add_column :indicators, :public, :boolean
  end
end
