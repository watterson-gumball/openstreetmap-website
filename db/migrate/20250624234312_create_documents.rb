class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :document_type
      t.string :region_name

      t.timestamps
    end
  end
end
