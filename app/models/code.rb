# == Schema Information
#
# Table name: codes
#
#  id         :bigint           not null, primary key
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_codes_on_value  (value)
#
class Code < ApplicationRecord
  has_many :code_documents
  has_many :documents, through: :code_documents
end