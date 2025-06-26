# == Schema Information
#
# Table name: documents
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Document < ApplicationRecord
  has_one_attached :file, :service => Settings.document_storage
  has_many :code_documents
  has_many :codes, through: :code_documents
end
