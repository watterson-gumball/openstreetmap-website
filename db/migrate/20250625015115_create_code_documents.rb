class CreateCodeDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :code_documents do |t|
      t.references :code, null: false, foreign_key: true
      t.references :document, null: false, foreign_key: true

      t.timestamps
    end

    add_index :code_documents, [:code_id, :document_id], unique: true
  end
end
