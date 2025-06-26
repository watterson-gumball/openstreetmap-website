class CreateCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :codes do |t|
      t.string :value

      t.timestamps
    end
    add_index :codes, :value
  end
end
