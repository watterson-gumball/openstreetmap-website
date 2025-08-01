# == Schema Information
#
# Table name: documents
#
#  id            :bigint           not null, primary key
#  title         :string
#  document_type :string
#  region_name   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  date          :string
#
class Document < ApplicationRecord
  has_one_attached :file, :service => Settings.document_storage
  has_many :code_documents
  has_many :codes, through: :code_documents

  # def have_mismatch?
  #   @have_mismatch ||= codes.any?(&:child_code_present?)
  # end
end
