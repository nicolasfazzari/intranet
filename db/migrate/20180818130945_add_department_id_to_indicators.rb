class AddDepartmentIdToIndicators < ActiveRecord::Migration
  def change
    add_column :indicators, :department_id, :integer
  end
end
