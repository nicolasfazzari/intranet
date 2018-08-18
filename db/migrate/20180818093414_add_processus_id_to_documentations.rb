class AddProcessusIdToDocumentations < ActiveRecord::Migration
  def change
    add_column :documentations, :processus_id, :integer
  end
end
