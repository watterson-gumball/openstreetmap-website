# == Schema Information
#
# Table name: codes
#
#  id         :bigint           not null, primary key
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :bigint
#
# Indexes
#
#  index_codes_on_value  (value)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => codes.id)
#
class Code < ApplicationRecord
  belongs_to :current_in_use, class_name: "Code", foreign_key: :parent_id, optional: true
  has_one :on_row,  class_name: "Code", foreign_key: :parent_id, dependent: :destroy
  has_many :code_documents
  has_many :documents, through: :code_documents
end
