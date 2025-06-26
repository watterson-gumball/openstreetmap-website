# == Schema Information
#
# Table name: code_documents
#
#  id          :bigint           not null, primary key
#  code_id     :bigint           not null
#  document_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_code_documents_on_code_id                  (code_id)
#  index_code_documents_on_code_id_and_document_id  (code_id,document_id) UNIQUE
#  index_code_documents_on_document_id              (document_id)
#
# Foreign Keys
#
#  fk_rails_...  (code_id => codes.id)
#  fk_rails_...  (document_id => documents.id)
#
class CodeDocument < ApplicationRecord
  belongs_to :code
  belongs_to :document
end
