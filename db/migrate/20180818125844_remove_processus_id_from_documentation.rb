class RemoveProcessusIdFromDocumentation < ActiveRecord::Migration
  def change
    remove_column :documentations, :processus_id, :integer
  end
end
