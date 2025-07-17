class AddCodesSelfReference < ActiveRecord::Migration[8.0]
  def change
    add_column :codes, :parent_id, :bigint
    add_foreign_key :codes, :codes, column: :parent_id, validate: false
  end
end
