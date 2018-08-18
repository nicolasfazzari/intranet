class AddDepartmentIdToDocumentations < ActiveRecord::Migration
  def change
    add_column :documentations, :department_id, :integer
  end
end
